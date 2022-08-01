# -*- coding: utf-8 -*-
import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
import plotly.express as px

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)




df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_apple_stock.csv')

fig = px.line(df, x = 'AAPL_x', y = 'AAPL_y', title='Apple Share Prices over time (2014)')
fig.show()



app.layout = html.Div(children=[
    html.H1(children='Hello Dash'),

    html.Div(children='''
        Dash: A web application framework for Python.
    '''),

    dcc.Graph(
        id='example-graph',
        figure={
            'data': [
                {'x': [1, 2, 3], 'y': [4, 1, 2], 'type': 'bar', 'name': 'SF'},
                {'x': [1, 2, 3], 'y': [2, 4, 5], 'type': 'line', 'name': u'Montréal'},
                {'x': [1, 2, 3], 'y': [ 3, 5, 7], 'type': 'line', 'name': u'Paris'}
            ],
            'layout': {
                'title': 'Dash Data Visualization'
            }
        }
    ),
dcc.Graph(
        id='aapl-graph',
        figure={
            'data': [
                {'x': df.AAPL_x , 'y': df.AAPL_y, 'type': 'line', 'name': 'Apple'}
            ],
            'layout': {
                'title': 'Dash Data Visualization'
            }
        }
    )

])

if __name__ == '__main__':
    app.run_server(debug=True)
