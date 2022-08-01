# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.
import dash
from dash import dcc
from dash import html
import plotly.express as px
from plotly.subplots import make_subplots
import pandas as pd

app = dash.Dash(__name__)

### 1 ### Import data ########################################

# assume you have a "long-form" data frame
# see https://plotly.com/python/px-arguments/ for more options


Pokemons = pd.read_csv('All_Pokemon.csv', sep=',', index_col="Number")

df = pd.DataFrame(Pokemons, columns=["Name", "Generation", "Type 1", "Type 2", "Height", "Weight", "BMI"])

types = (df.copy().groupby(['Type 1', 'Type 2']).size()
         .sort_values(ascending=False)
         .reset_index(name='count'))
types.sort_values(by=['Type 1', 'Type 2', 'count'], ascending=True, inplace=True)

types_ByGeneration = (df.copy().groupby(['Type 1', 'Type 2','Generation']).size()
         .sort_values(ascending=False)
         .reset_index(name='count'))
types_ByGeneration.sort_values(by=['Generation'], ascending=True, inplace=True)

Dominant_Types = types.copy()
maxima = Dominant_Types.groupby('Type 1')['count'].max()
Dominant_Types['max'] = Dominant_Types['Type 1'].map(maxima)
Dominant_Types = Dominant_Types[Dominant_Types["count"] == Dominant_Types['Type 1'].map(maxima)]
Dominant_Types.sort_values(by=['Type 1', 'Type 2', 'count'], ascending=True, inplace=True)

### 2 ### Create charts ########################################

fig = px.treemap(types, path=["Type 1", "Type 2"], values='count', title="Pokemon Types", color="Type 1",
                 color_discrete_map=dict(Grass="lightGreen", Bug="greenyellow", Normal="Grey", Water="skyblue",
                                         Rock="saddlebrown", Psychic="deepPink", Dark="#36373c", Fire="orangered",
                                         Electric="#ffff33 ", Steel="#9ea4a6", Ghost="#c3c6cd", Dragon="#0736a4",
                                         Ice="#00f2fc", Ground="#c1790b", Poison="#8f0ef1", Fighting="#f32946",
                                         Flying="#6bc4f6", Fairy="#ff87c5"))
fig2 = px.treemap(Dominant_Types, path=["Type 1", "Type 2"], color="Type 1", values='max',
                  title="Pokemon Dominant Types",
                  color_discrete_map=dict(Grass="lightGreen", Bug="greenyellow", Normal="Grey", Water="skyblue",
                                          Rock="saddlebrown", Psychic="deepPink", Dark="#36373c", Fire="orangered",
                                          Electric="#ffff33 ", Steel="#9ea4a6", Ghost="#c3c6cd", Dragon="#0736a4",
                                          Ice="#00f2fc", Ground="#c1790b", Poison="#8f0ef1", Fighting="#f32946",
                                          Flying="#6bc4f6", Fairy="#ff87c5"))

fig3 = px.scatter(df[df["BMI"] <= 100], x="Type 1", y="BMI", color="Type 1", size="BMI",
                  hover_data=['BMI', 'Name'],title="Pokemon BMI's",
                  color_discrete_map=dict(Grass="lightGreen", Bug="greenyellow", Normal="Grey", Water="skyblue",
                                          Rock="saddlebrown", Psychic="deepPink", Dark="#36373c", Fire="orangered",
                                          Electric="#ffff33 ", Steel="#9ea4a6", Ghost="#c3c6cd", Dragon="#0736a4",
                                          Ice="#00f2fc", Ground="#c1790b", Poison="#8f0ef1", Fighting="#f32946",
                                          Flying="#6bc4f6", Fairy="#ff87c5"))

fig4 = px.scatter(df[(df["Type 1"] == "Dark") & (df["Height"] <= 2) & (df["Weight"] <= 150)], x="Height", y="Weight",
                  color="Type 1",
                  size="Weight",
                  hover_data=['BMI', 'Name'],title="Pokemon Height and weight",
                  color_discrete_map=dict(Grass="lightGreen", Bug="greenyellow", Normal="Grey", Water="skyblue",
                                          Rock="saddlebrown", Psychic="deepPink", Dark="#36373c", Fire="orangered",
                                          Electric="#ffff33 ", Steel="#9ea4a6", Ghost="#c3c6cd", Dragon="#0736a4",
                                          Ice="#00f2fc", Ground="#c1790b", Poison="#8f0ef1", Fighting="#f32946",
                                          Flying="#6bc4f6", Fairy="#ff87c5"))

fig5 = px.histogram(types_ByGeneration[types_ByGeneration["Generation"]<=2], x='Type 1', y='count',facet_col="Generation",
                  title="# of Pokemons By generation",color='Type 1', hover_data=['Generation'],color_discrete_map=dict(Grass="lightGreen", Bug="greenyellow", Normal="Grey", Water="skyblue",
                                          Rock="saddlebrown", Psychic="deepPink", Dark="#36373c", Fire="orangered",
                                          Electric="#ffff33 ", Steel="#9ea4a6", Ghost="#c3c6cd", Dragon="#0736a4",
                                          Ice="#00f2fc", Ground="#c1790b", Poison="#8f0ef1", Fighting="#f32946",
                                          Flying="#6bc4f6", Fairy="#ff87c5"))


### 3 ### Design the dashboard #################################


app.layout = (
    html.Div(children=[

        html.Div(children='''
    Graph 1
    '''),
        dcc.Graph(
            id='Pokemon-types-treemap',
            figure=fig
        ),

        html.Div(children='''
    Graph 2
  '''),
        dcc.Graph(
            id='Pokemon-dominant-types-treemap',
            figure=fig2
        ),

        html.Div(children='''
  Graph 3 -4
'''),
        dcc.Graph(
            id='Pokemon-BMI',
            figure=fig3
        ),
        dcc.Graph(
            id='Pokemon-Grass-BMI',
            figure=fig4
        ),
        html.Div(children='''
   Graph 5
 '''),
        dcc.Graph(
            id='Poke-types-treemap',
            figure=fig5
        ),


    ]))

###############################################################
if __name__ == '__main__':
    app.run_server(debug=True)
