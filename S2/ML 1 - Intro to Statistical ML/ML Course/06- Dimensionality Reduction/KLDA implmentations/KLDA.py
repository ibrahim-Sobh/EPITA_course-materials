
from scipy.sparse.linalg import eigsh
from scipy.sparse import eye
from sklearn.base import BaseEstimator, ClassifierMixin, TransformerMixin
from sklearn.metrics import pairwise_kernels
from sklearn.neighbors import NearestCentroid
from sklearn.utils.multiclass import unique_labels
from sklearn.utils.validation import check_X_y, check_array, check_is_fitted
from sklearn.preprocessing import OneHotEncoder
import numpy as np


class KLDA(BaseEstimator, ClassifierMixin, TransformerMixin):
    
    def __init__(self, n_components=2, kernel='linear', robustness_offset=1e-8,**kwds):
        self.kernel = kernel
        self.n_components = n_components
        self.kwds = kwds
        self.robustness_offset = robustness_offset

        if kernel is None:
            self.kernel = 'linear'

    def fit(self, X, y):
        X, y = check_X_y(X, y)
        self.classes_ = unique_labels(y)
        if self.n_components > self.classes_.size - 1:
            print("n_components > classes_.size - 1. Only the first classes_.size - 1 components will be valid.")
            pass
         
        self.X_ = X
        self.y_ = y

        y_onehot = OneHotEncoder().fit_transform(
            self.y_[:, np.newaxis])

        K = pairwise_kernels(
            X, X, metric=self.kernel, **self.kwds)

        m_classes = y_onehot.T @ K / y_onehot.T.sum(1)
        indices = (y_onehot @ np.arange(self.classes_.size)).astype('i')
        N = K @ (K - m_classes[indices])

        # Add value to diagonal for rank robustness
        N += eye(self.y_.size) * self.robustness_offset

        m_classes_centered = m_classes - K.mean(1)
        M = m_classes_centered.T @ m_classes_centered

        # Find weights
        w, self.weights_ = eigsh(M, self.n_components, N, which='LM')

        # Compute centers
        centroids_ = m_classes @ self.weights_

        # Train nearest centroid classifier
        self.clf_ = NearestCentroid().fit(centroids_, self.classes_)

        return self

    def transform(self, X):
        check_is_fitted(self)
        return pairwise_kernels(
            X, self.X_, metric=self.kernel, **self.kwds
        ) @ self.weights_

    def predict(self, X):

        check_is_fitted(self)

        X = check_array(X)

        projected_points = self.transform(X)
        predictions = self.clf_.predict(projected_points)

        return predictions

    def fit_additional(self, X, y):
  
        check_is_fitted(self)
        X, y = check_X_y(X, y)

        new_classes = np.unique(y)

        projections = self.transform(X)
        y_onehot = OneHotEncoder().fit_transform(
            y[:, np.newaxis])
        new_centroids = y_onehot.T @ projections / y_onehot.T.sum(1)

        concatenated_classes = np.concatenate([self.classes_, new_classes])
        concatenated_centroids = np.concatenate(
            [self.clf_.centroids_, new_centroids])

        self.clf_.fit(concatenated_centroids, concatenated_classes)

        return self