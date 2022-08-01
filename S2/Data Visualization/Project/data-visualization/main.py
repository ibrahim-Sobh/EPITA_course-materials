import dash.exceptions
from dash import Dash, html, dcc, Output, Input
import plotly.express as px
import pandas as pd
import plotly.graph_objs as go
import plotly.figure_factory as ff
import numpy as np
import plotly.graph_objects as go
from plotly.subplots import make_subplots

df_stud1 = pd.read_csv('student-mat.csv', sep=';')
df_stud2 = pd.read_csv('student-por.csv', sep=';')
df_students = pd.concat([df_stud1, df_stud2], axis=0)

male_data = df_students.query('sex=="M"')
female_data = df_students.query('sex=="F"')

df_students = pd.concat([df_stud1, df_stud2], axis=0)
df_students_Join = df_stud1.merge(df_stud2,
                                  on=["school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob",
                                      "Fjob", "reason", "nursery", "internet"])
df_students.groupby(
    ["school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery",
     "internet"]).mean()
df_students

# --------------------------------------------------------------------------------------------------------------#
# A- The effect of Studying Time and having Internet access on th performance of the Students
df_SI_Time = df_students.loc[:, ["studytime", "internet", "G1", "G2", "G3"]]
df_SI_Time["Grade"] = round((df_SI_Time["G1"] + df_SI_Time["G2"] + df_SI_Time["G3"]) / 3, 2)
df_SI_Time = df_SI_Time.loc[:, ["internet", "studytime", "Grade"]]
df_SI_Time = (df_SI_Time.groupby(["internet", "studytime", "Grade"]).size()
              .sort_values(ascending=False)
              .reset_index(name='Number of Students'))
df_SI_Time = df_SI_Time.sort_values(by=["studytime"])
fig0 = px.histogram(df_SI_Time, y="Number of Students", x="Grade", color="internet", facet_col="studytime",
                    category_orders={"internet": ["yes", "no"]},
                    color_discrete_map={"yes": "#19D3F3", "no": "#2E91E5"})
fig0.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                              '<b>The effect of Studying Time and having Internet access on the performance of the '
                              'Students</b>'
                              '</SPAN> ', title_x=0.5, margin=dict(t=100, b=100))
fig0.add_annotation(
    x=0.5, y=-0.35,
    text="We can see that Studying while having Internet Access can affect negatively the performance(grades) of "
         "students.",
    font_size=15,
    xref="paper", yref="paper",
    showarrow=False,
    bordercolor='red',
    borderpad=10
)

# --------------------------------------------------------------------------------------------------------------#

# B - the impact of study time and free time on studdent performance
df_SF_Time = df_students.loc[:, ["studytime", "failures", "G1", "G2", "G3"]]
df_SF_Time["Grade"] = round((df_SF_Time["G1"] + df_SF_Time["G2"] + df_SF_Time["G3"]) / 3, 2)
df_SF_Time = df_SF_Time.loc[:, ["studytime", "failures", "Grade"]]
df_SF_Time = (df_SF_Time.groupby(["studytime", "failures", "Grade"]).size()
              .sort_values(ascending=False)
              .reset_index(name='Number of Students'))
df_SF_Time = df_SF_Time.sort_values(by=["studytime", "failures", "Number of Students", "Grade"])
df_SF_Time

fig1 = px.scatter(df_SF_Time, x="Grade", y="Number of Students", color="failures", facet_col="studytime",
                  color_continuous_scale="deep_r")

fig1.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                              '<b>The impact of study time on the number of past class Failures</b>'
                              '</SPAN> ', title_x=0.5, margin=dict(t=100, b=100))
fig1.add_annotation(
    x=0.5, y=-0.35,
    text="We can see that Studying time can drastically decrease the number of failures a student can have.",
    font_size=15,
    xref="paper", yref="paper",
    showarrow=False,
    bordercolor='red',
    borderpad=10
)

# --------------------------------------------------------------------------------------------------------------#

# C - The effect of going out and use of alchohol on students performance Grades
df_GoOut_Alcohol = df_students.loc[:, ["Dalc", "Walc", "goout", "failures", "G1", "G2", "G3"]]
df_GoOut_Alcohol["Grade"] = round((df_GoOut_Alcohol["G1"] + df_GoOut_Alcohol["G2"] + df_GoOut_Alcohol["G3"]) / 3, 2)
df_GoOut_Alcohol["Grade_appreciation"] = 0
df_GoOut_Alcohol["Grade_appreciation"] = df_GoOut_Alcohol["Grade_appreciation"].mask(df_GoOut_Alcohol["Grade"] < 8,
                                                                                     "grade less than 8")
df_GoOut_Alcohol["Grade_appreciation"] = df_GoOut_Alcohol["Grade_appreciation"].mask(
    (df_GoOut_Alcohol["Grade"] >= 8) & (df_GoOut_Alcohol["Grade"] < 13), "grade between 8 and 12")
df_GoOut_Alcohol["Grade_appreciation"] = df_GoOut_Alcohol["Grade_appreciation"].mask(df_GoOut_Alcohol["Grade"] >= 13,
                                                                                     "grade over 13")
df_GoOut_Alcohol["Alcohol"] = round((df_GoOut_Alcohol["Dalc"] + df_GoOut_Alcohol["Walc"]) / 2, 0)
df_GoOut_Alcohol["Alcohol_General_Consumption"] = df_GoOut_Alcohol.Alcohol.map({1: 'very low consumption of alcohol',
                                                                                2: 'low consumption of alcohol',
                                                                                3: 'medium consumption of alcohol',
                                                                                4: 'high consumption of alcohol',
                                                                                5: 'very high consumption of alcohol'})
df_GoOut_Alcohol["goout_Def"] = df_GoOut_Alcohol.Alcohol.map({1: 'go out very rarely',
                                                              2: 'go out rarely',
                                                              3: 'go out sometime',
                                                              4: 'go out often',
                                                              5: 'go out a lot'})
df_GoOut_Alcohol = (
    df_GoOut_Alcohol.groupby(["goout_Def", "Grade_appreciation", "Grade", "Alcohol_General_Consumption"]).size()
    .sort_values(ascending=False)
    .reset_index(name='Number of Students'))
df_GoOut_Alcohol.sort_values(
    by=["goout_Def", "Number of Students", "Grade_appreciation", "Alcohol_General_Consumption"])
df_GoOut_Alcohol

# --------------------------------------------------------------------------------------------------------------#
# D - The effect of alchohol on students health
df_Alcohol_Health = df_students.loc[:, ["Dalc", "Walc", "health"]]
df_Alcohol_Health["Alcohol"] = round((df_Alcohol_Health["Dalc"] + df_Alcohol_Health["Walc"]) / 2, 0)
df_Alcohol_Health["health_desc"] = df_Alcohol_Health.health.map({1: 'very bad condition of health',
                                                                 2: 'bad condition of health',
                                                                 3: 'medium condition of health',
                                                                 4: 'good condition of health',
                                                                 5: 'very good condition of health'})
df_Alcohol_Health = (df_Alcohol_Health.groupby(["Alcohol", "health_desc"]).size()
                     .sort_values(ascending=False)
                     .reset_index(name='Number of Students'))
df_Alcohol_Health

# --------------------------------------------------------------------------------------------------------------#
# H- the effect of having family, School support and Private classes on performance of students
df_support = df_students.loc[:, ["schoolsup", "famsup", "paid", "G1", "G2", "G3"]]
df_support["Grade"] = round((df_support["G1"] + df_support["G2"] + df_support["G3"]) / 3, 2)
df_support = df_support.loc[:, ["schoolsup", "famsup", "paid", "Grade"]]
df_support["schoolsup"] = df_support.schoolsup.map(dict(yes=1, no=0))
df_support["famsup"] = df_support.famsup.map(dict(yes=1, no=0))
df_support["paid"] = df_support.paid.map(dict(yes=1, no=0))
df_support["support"] = df_support['schoolsup'].astype(str) + df_support['famsup'].astype(str) + df_support[
    'paid'].astype(str)
df_support = df_support.sort_values(by=["support"])
df_support["support"] = df_support.support.replace({'000': 'No support',
                                                    '001': 'Private classes',
                                                    '010': 'Family',
                                                    '100': 'School',
                                                    '011': 'Family & Private classes',
                                                    '110': 'School & Family',
                                                    '101': 'School & Private classes',
                                                    '111': 'School & Family & Private classes'})
df_support = (df_support.groupby(["support", "Grade"]).size()
              .sort_values(ascending=False)
              .reset_index(name='Number of Students'))
df_support = df_support.sort_values(by=["Grade"])

# --------------------------------------------------------------------------------------------------------------#
# E-  the performance level difference between genders an ages
df_gender_ages = df_students.loc[:, ["sex", "age", "G1", "G2", "G3"]]
df_gender_ages["Grade"] = round((df_gender_ages["G1"] + df_gender_ages["G2"] + df_gender_ages["G3"]) / 3, 2)
df_gender_ages = df_gender_ages.loc[:, ["sex", "age", "Grade"]]
df_gender_ages = (df_gender_ages.groupby(["sex", "age", "Grade"]).size()
                  .sort_values(ascending=False)
                  .reset_index(name='#Students'))
df_gender_ages = df_gender_ages.sort_values(by=["Grade", "#Students", "age"])

# F- 8-the effect of travel time and reason on absences
df_TT_Loc_Rsn = df_students.loc[:, ["address", "traveltime", "reason", "absences", "G1", "G2", "G3"]].sort_values(
    by=["reason", "traveltime", "address", "absences"])
df_TT_Loc_Rsn["Grade"] = round((df_TT_Loc_Rsn["G1"] + df_TT_Loc_Rsn["G2"] + df_TT_Loc_Rsn["G3"]) / 3, 0)
df_TT_Loc_Rsn["Location"] = df_TT_Loc_Rsn.address.map({'R': 'Rural',
                                                       'U': 'Urban'})
df_TT_Loc_Rsn["Trvl_Time"] = df_TT_Loc_Rsn.traveltime.map({1: "<15 min",
                                                           2: "15 to 30 min",
                                                           3: "30 min to 1 hour",
                                                           4: ">1 hour"})
# df_TT_Loc_Rsn.groupby(by=["Trvl_Time","reason","Location"]).mean().loc[:,["absences","Grade"]]


# --------------------------------------------------------------------------------------------------------------#
# 6-the effect of mother and father backgounrd(education and jobs) on student aiming for higher education
df_S_bkgrd = df_students.loc[:, ["Medu", "Fedu", "Mjob", "Fjob", "higher", "G1", "G2", "G3"]]
df_S_bkgrd["Grade"] = round((df_S_bkgrd["G1"] + df_S_bkgrd["G2"] + df_S_bkgrd["G3"]) / 3, 2)
df_S_bkgrd = df_S_bkgrd.loc[:, ["Medu", "Fedu", "Mjob", "Fjob", "Grade", "higher"]]

df_S_bkgrd["Medu1"] = df_S_bkgrd.Medu.map({0: 'Numeric',
                                           1: 'Primary 1st -> 4th',
                                           2: 'Primary 5th -> 9th',
                                           3: 'Secondary',
                                           4: 'Higher'})
df_S_bkgrd["Fedu1"] = df_S_bkgrd.Fedu.map({0: 'Numeric',
                                           1: 'Primary 1st -> 4th',
                                           2: 'Primary 5th -> 9th',
                                           3: 'Secondary',
                                           4: 'Higher'})

df_S_bkgrd["Mjob1"] = df_S_bkgrd.Mjob.map(dict(teacher=0, health=1, services=2, at_home=3, other=4))
df_S_bkgrd["back"] = df_S_bkgrd["Mjob"].copy()
df_S_bkgrd["Mjob"] = df_S_bkgrd["Mjob1"].copy()
df_S_bkgrd["Mjob1"] = df_S_bkgrd["back"].copy()

df_S_bkgrd["Fjob1"] = df_S_bkgrd.Fjob.map(dict(teacher=0, health=1, services=2, at_home=3, other=4))
df_S_bkgrd["back1"] = df_S_bkgrd["Fjob"].copy()
df_S_bkgrd["Fjob"] = df_S_bkgrd["Fjob1"].copy()
df_S_bkgrd["Fjob1"] = df_S_bkgrd["back1"].copy()

df_S_bkgrd_MF = df_S_bkgrd.loc[:,
                ["Medu", "Medu1", "Mjob", "Mjob1", "Fedu", "Fedu1", "Fjob", "Fjob1", "Grade", "higher"]]
df_S_bkgrd_MF = (df_S_bkgrd_MF.groupby(
    ["Medu", "Medu1", "Mjob", "Mjob1", "Fedu", "Fedu1", "Fjob", "Fjob1", "Grade", "higher"]).size()
                 .sort_values(ascending=False)
                 .reset_index(name='Number of Students'))
df_S_bkgrd_MF = df_S_bkgrd_MF.sort_values(by="Grade")
df_S_bkgrd_MF

# I -9 having a fullfied emotional needs ( family,relationship,extracurricular) effect on performance
# df_EmtFll = df_students.loc[:, ["famsup", "romantic", "activities", "G1", "G2", "G3"]]
# df_EmtFll["Grade"] = round((df_EmtFll["G1"] + df_EmtFll["G2"] + df_EmtFll["G3"]) / 3, 2)
# df_EmtFll=df_students.groupby(by=["famsup","romantic","activities"],as_index=False).mean().loc[:,["famsup","romantic","activities","absences", "Grade"]]


# Application  Dash
# external_stylesheets=['https://codepen.io/chriddyp/pen/bWLwgP.css']
app = Dash(__name__)
server = app.server
app.layout = html.Div(children=[

    html.H1(children='Student Performance'),
    html.H2(children='We chose to perform analysis on the performances of students from 2 schools in Portugal. '
                     'The aim of the following graphs is to highlight the different factors impact on the grades / performance (such as the family support, alcohol frequency of use,etc...)'),
    html.Div(children=[
        dcc.Graph(id='SF_Time',
                  figure=fig0,
                  )
    ]),
    dcc.Graph(
        id='SI_Performance',
        figure=fig1
    ),
    html.Div(children=[
        # html.H2("The effect of going out and use of alchohol on students performance Grades", style={"justify": "center", "text-decoration": "underline"}),
        html.H4("FilterBy:"),
        dcc.Checklist(
            id='CbxAlcGout',
            options=[
                {'label': 'Alcohol consumption (on daily basis)', 'value': 'Alcohol_General_Consumption'},
                {'label': 'Going out', 'value': 'goout_Def'}
            ],
            value=['Alcohol_General_Consumption', 'goout_Def'],
            inputStyle={'margin-left': '20px'}
        ),
        dcc.Graph(id="GA_Performance")
    ]),
    html.Div(children=[
        # html.H2("The effect of alchohol use on students health", style={"justify": "center", "text-decoration": "underline"}),
        html.H4("FilterBy:"),
        dcc.RadioItems(
            id='RbxAlcHealth',
            options=[
                {'label': 'very low consumption of alcohol', 'value': '1'},
                {'label': 'low consumption of alcohol', 'value': '2'},
                {'label': 'medium consumption of alcohol', 'value': '3'},
                {'label': 'high consumption of alcohol', 'value': '4'},
                {'label': 'very high consumption of alcohol', 'value': '5'},
            ],
            value='1',
            inputStyle={'margin-left': '20px'}
        ),
        dcc.Graph(id="Alc_Health")
    ]),
    html.Div(children=[
        html.H4("Filter on:"),
        dcc.RadioItems(
            id='RbxTTRsn',
            options=[
                {'label': 'Travel time', 'value': 'Trvl_Time'},
                {'label': 'Reason to attend the school', 'value': 'reason'},
            ],
            value='Trvl_Time',
            inputStyle={'margin-left': '20px'}
        ),
        dcc.Graph(id="TTLocRsn_absences")
    ]),
    # html.Div(children=[
    #         html.H4("Family support:"),
    #         dcc.RadioItems(
    #            id='Rbxfmsp',
    #            options=[
    #                {'label': 'Yes', 'value': 'yes'},
    #                {'label': 'No', 'value': 'no'},
    #            ],
    #            value='yes',
    #             inputStyle = {'margin-left':'20px'}
    #         ),
    #         html.H4("In romance:"),
    #         dcc.RadioItems(
    #            id='Rbxrmtc',
    #            options=[
    #                {'label': 'Yes', 'value': 'yes'},
    #                {'label': 'No', 'value': 'no'},
    #            ],
    #            value='yes',
    #             inputStyle = {'margin-left':'20px'}
    #         ),
    #         html.H4("Extra curricular activities:"),
    #         dcc.RadioItems(
    #            id='Rbxxcrr',
    #            options=[
    #                {'label': 'Yes', 'value': 'yes'},
    #                {'label': 'No', 'value': 'no'},
    #            ],
    #            value='yes',
    #             inputStyle = {'margin-left':'20px'}
    #         ),
    #         dcc.Graph(id="EmtFlfllmnt_Perfs")
    # ]),
    html.Div(children=[
        html.H4("Supporter 1"),
        dcc.Dropdown(sorted(df_support['support'].unique()), "Family", id='support_drop')

    ], style={'width': '30%', 'display': 'inline-block'}),
    html.Div(style={'width': '5%', 'display': 'inline-block'}),
    html.Div(children=[
        html.H4("Supporter 2"),
        dcc.Dropdown(sorted(df_support['support'].unique()), "School", id='support_drop1')

    ], style={'width': '30%', 'display': 'inline-block'}),

    dcc.Graph(id='ScFmPa_S_Time'),

    html.Div(children=[
        html.H4("From Age"),
        dcc.Dropdown(sorted(df_gender_ages['age'].unique()), 15, id='age_drop')

    ], style={'width': '20%', 'display': 'inline-block'}),
    html.Div(style={'width': '5%', 'display': 'inline-block'}),
    html.Div(children=[
        html.H4("To Age"),
        dcc.Dropdown(sorted(df_gender_ages['age'].unique()), 15, id='age_drop_1')

    ], style={'width': '20%', 'display': 'inline-block'}),
    dcc.Graph(id='Sex_Age_Grades'),

    html.Div(children=[
        html.H4("Mother Education"),
        dcc.Slider(0, 4,
                   step=None,
                   id='slider_Medu',
                   marks={0: 'Numeric',
                          1: 'Primary 1st -> 4th',
                          2: 'Primary 5th -> 9th',
                          3: 'Secondary',
                          4: 'Higher'},
                   value=2
                   )], style={'width': '50%', 'display': 'inline-block'}),
    html.Div(children=[
        html.H4("Mother Job"),
        dcc.Slider(0, 4,
                   step=None,
                   id='slider_Mjob',
                   marks={0: 'Teacher',
                          1: 'Health',
                          2: 'Services',
                          3: 'At_home',
                          4: 'Other'},
                   value=1
                   )], style={'width': '50%', 'display': 'inline-block'}),
    html.Div(children=[
        html.H4("Father Education"),
        dcc.Slider(0, 4,
                   step=None,
                   id='slider_Fedu',
                   marks={0: 'Numeric',
                          1: 'Primary 1st -> 4th',
                          2: 'Primary 5th -> 9th',
                          3: 'Secondary',
                          4: 'Higher'},
                   value=1
                   )], style={'width': '50%', 'display': 'inline-block'}),
    html.Div(children=[
        html.H4("Father Job"),
        dcc.Slider(0, 4,
                   step=None,
                   id='slider_Fjob',
                   marks={0: 'Teacher',
                          1: 'Health',
                          2: 'Services',
                          3: 'At_home',
                          4: 'Other'},
                   value=2
                   )], style={'width': '50%', 'display': 'inline-block'}),
    dcc.Graph(id='Medu_Mjob_Higher')

])


@app.callback(
    Output(component_id='ScFmPa_S_Time', component_property='figure'),
    Input(component_id='support_drop', component_property='value'),
    Input(component_id='support_drop1', component_property='value'))
def update_graph(support_drop, support_drop1):
    if support_drop is None:
        support_drop = "Family"
    if support_drop1 is None:
        support_drop1 = "School"

    df = df_support[(df_support['support'] == support_drop) | (df_support['support'] == support_drop1)]
    fig = px.line(df, y="Number of Students", x="Grade", color=df_support.columns[0],
                  color_discrete_map={'No support': '#636EFA',
                                      'Private classes': '#2CA02C',
                                      'Family': '#AB63FA',
                                      'School': '#17BECF',
                                      'Family & Private classes': '#FF7F0E',
                                      'School & Family': '#9D755D',
                                      'School & Private classes': '#F32D0D',
                                      'School & Family & Private classes': '#00CC96'})
    fig.update_layout(
        title_text='',
        title_x=0.5, margin=dict(t=100))
    fig.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                                 '<b>The effect of having Family, School Support and Private Classes on Student Performance.</b>'
                                 '</SPAN> ', title_x=0.5, margin=dict(t=100))

    return fig


@app.callback(
    Output(component_id='Sex_Age_Grades', component_property='figure'),
    Input(component_id='age_drop', component_property='value'),
    Input(component_id='age_drop_1', component_property='value'))
def update_graph_1(age_drop, age_drop_1):
    if age_drop is None:
        age_drop = 15
    if age_drop_1 is None:
        age_drop_1 = 15
    if age_drop > age_drop_1:
        temp = age_drop
        age_drop = age_drop_1
        age_drop_1 = temp

    df = df_gender_ages[(df_gender_ages['age'] >= age_drop) & (df_gender_ages['age'] <= age_drop_1)]
    df = df.sort_values(by=["age"])
    fig_t = px.area(df, x="Grade", y="#Students", color='sex',
                    facet_row='sex', facet_col='age',
                    category_orders={"sex": ["M", "F"]},
                    color_discrete_map={"M": "#19D3F3", "F": "#FF6692"})
    fig_t.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                                   '<b>Grades analysis between Genders and Ages.</b>'
                                   '</SPAN> ', title_x=0.5, margin=dict(t=100))
    return fig_t


@app.callback(
    Output(component_id='Medu_Mjob_Higher', component_property='figure'),
    Input(component_id='slider_Medu', component_property='value'),
    Input(component_id='slider_Mjob', component_property='value'),
    Input(component_id='slider_Fedu', component_property='value'),
    Input(component_id='slider_Fjob', component_property='value'))
def update_graph_2(slider_Medu, slider_Mjob, slider_Fedu, slider_Fjob):
    df = df_S_bkgrd_MF[(df_S_bkgrd_MF['Medu'] == slider_Medu) & (df_S_bkgrd_MF['Mjob'] == slider_Mjob) |
                       (df_S_bkgrd_MF['Fedu'] == slider_Fedu) & (df_S_bkgrd_MF['Fjob'] == slider_Fjob)]
    df = df.sort_values(by=["Grade"])
    fig_t = px.bar(df, x="Grade", y="Number of Students", color='higher',
                   category_orders={"higher": ["yes", "no"]},
                   color_discrete_map={  # replaces default color mapping by value
                       "yes": "#16FF32", "no": "#FB0D0D"
                   })
    fig_t.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                                   '<b>The effect of Mother & Father background on Grades & Number of students aiming '
                                   'for higher education.</b> '
                                   '</SPAN> ', title_x=0.5, margin=dict(t=100, b=100))
    fig_t.add_annotation(
        x=0.5, y=-0.35,
        text="We can see that parents with higher educational background & social status have children that more likely "
             "will aim for higher education .",
        font_size=15,
        xref="paper", yref="paper",
        showarrow=False,
        bordercolor='red',
        borderpad=10
    )
    return fig_t


# C- Section going out and alcohol consumption impact on performance
@app.callback(
    Output(component_id='GA_Performance', component_property='figure'),
    Input(component_id='CbxAlcGout', component_property='value'))
def update_graph_3(CbxAlcGout):
    if CbxAlcGout is None:
        pathFig = ["Alcohol_General_Consumption"]
    pathFig = [*CbxAlcGout, 'Grade_appreciation', 'Grade']
    fig = px.treemap(df_GoOut_Alcohol,
                     path=pathFig,
                     values='Number of Students',
                     color='Grade',  # hover_data=['Number of Students'],
                     color_continuous_scale='ylorrd',
                     color_continuous_midpoint=np.average(df_GoOut_Alcohol['Grade'],
                                                          weights=df_GoOut_Alcohol['Number of Students']))
    fig.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                                 '<b>The effect of going out and use of alchohol on students performance Grades</b>'
                                 '</SPAN> ', title_x=0.5, margin=dict(t=100))
    fig.add_annotation(
        x=0.5, y=-0.25,
        text="The majority of good grades are gotten by the students who don't Go out so often with their "
             "friends and also don't drink Alcohol or drink very little of it.",
        font_size=15,
        xref="paper", yref="paper",
        showarrow=False,
        bordercolor='red',
        borderpad=10
    )
    return fig


# D- Section going out and alcohol consumption impact on performance
@app.callback(
    Output(component_id='Alc_Health', component_property='figure'),
    Input(component_id='RbxAlcHealth', component_property='value'))
def update_graph_4(RbxAlcHealth):
    df_AH = df_Alcohol_Health.query("Alcohol==" + str(int(RbxAlcHealth)))
    df_AH.sort_values(by=["health_desc", "Number of Students", "Alcohol"])
    fig = px.pie(df_AH, values='Number of Students', names='health_desc', hole=0.4,color="health_desc",
                 color_discrete_map={"very bad condition of health": "#7f0000",
                                     "bad condition of health": "#990000",
                                     'medium condition of health': '#cc0000',
                                     'good condition of health': '#e50000',
                                     'very good condition of health': '#ff0000'})

    fig.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                                 '<b>The impact of alcohol use on students health</b>'
                                 '</SPAN> ', title_x=0.5, margin=dict(t=100))

    fig.update_layout(title_text='', title_x=0.5, margin=dict(t=100, b=100))
    fig.add_annotation(
        x=0.5, y=-0.35,
        text="The students have better health levels having less consumption of Alcohol.",
        font_size=15,
        xref="paper", yref="paper",
        showarrow=False,
        bordercolor='red',
        borderpad=10
    )
    return fig


# F- Section impact of travel time, reason and location on absences
@app.callback(
    Output(component_id='TTLocRsn_absences', component_property='figure'),
    Input(component_id='RbxTTRsn', component_property='value'))
def update_graph_5(RbxTTRsn):
    df_tmp = df_TT_Loc_Rsn.groupby(by=["Location", RbxTTRsn], as_index=False).sum()
    df_tmp.sort_values(by=['absences', RbxTTRsn])
    fig = px.funnel(df_tmp, x='absences', y=RbxTTRsn, color='Location')

    fig.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
                                 '<b>The impact of travel time, reason and location on students absences</b>'
                                 '</SPAN> ', title_x=0.5, margin=dict(t=100, b=100))

    fig.add_annotation(
        x=0.5, y=-0.35,
        text="We observe a great increase of absences when the students take little time to go school and the reason "
             "they join a school also impact the absences.",
        font_size=15,
        xref="paper", yref="paper",
        showarrow=False,
        bordercolor='red',
        borderpad=10)
    return fig


# I- Section impact of emtional fulfillement on performances
# @app.callback(
#     Output(component_id='EmtFlfllmnt_Perfs', component_property='figure'),
#     Input(component_id='Rbxfmsp', component_property='value'),
#     Input(component_id='Rbxrmtc', component_property='value'),
#     Input(component_id='Rbxxcrr', component_property='value'))
# def update_graph_6(Rbxfmsp,Rbxrmtc,Rbxxcrr):
#     df_EmtFll = df_EmtFll.query("famsup=='"+Rbxfmsp + "' & romantic=='"+Rbxrmtc + "' & activities=='"+Rbxxcrr+"'")
#     fig = px.histogram(df_EmtFll, x='absences', y='Grade', color='Location')
#
#     fig.update_layout(title_text='<SPAN STYLE="text-decoration:underline">'
#                                   '<b>The emotional fullfilment impact on Students performances and absences</b>'
#                                   '</SPAN> ', title_x=0.5, margin=dict(t=100))

# fig.update_layout(title_text='', title_x=0.5, margin=dict(t=100,b=100))
# fig.add_annotation(
#     x=0.5, y=-0.35,
#     text="The majority of good grades are gotten by the students who don't go out so often with their and also "
#          "don't drink alcohol or very little.",
#     font_size=15,
#     xref="paper", yref="paper",
#     showarrow=False,
#     bordercolor='red',
#     borderpad=10
# )
# return fig

if __name__ == '__main__':
    app.run_server(debug=True)
