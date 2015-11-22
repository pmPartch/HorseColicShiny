
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage(title = "Horse Colic Severity Indicator",
                   tabPanel(title = "Introduction",
                            h3("Warning: this application is not to be used for medical prognosis", align="center",style="color:red"),
                            h4("(this is only a proof of concept)",align="center",style="color:red"),
                            h3("Equine Colic"),
                            p("Equine colic is a general term for any sort of abdominal or digestive anomaly/discomfort and can be a life",
                              "threating condition for a horse. A few examples would be as follows:"),
                            HTML("<ul><li>",
                                 "The 2005 movie <i>The Brothers Grim</i> used a horse in an early scene shot in Czech Republic.",
                                 "During the night the stunt horse had developed colic symptoms and was either not diagnosed or was left untreated.",
                                 "It was found dead the following morning",
                                 "</li><li>Around 2003, I owned a horse that was ridden, groomed and put into his stall for the night and had",
                                 "no symptoms of colic...by morning it was in severe abdominal pain. Surgery discovered a ruptured colon and the horse was euthanized",
                                 "</li></ul>"),
                                  
                            p("Typically, this sort of quick onset does not happen and the owner/trainer has some time to decide on course of action.",
                              "For minor cases maybe a hand-walk and for more severe cases calling a veterinarian.",
                              "But the point being that this is a ",em("serious"), "issue for horses and requires some bit of skill to assess the proper course of action"),
                            h3("Equine Colic Severity Indication Application"),
                            p("A data set obtained from the UCI Machine Learning Repository (Horse Colic Data Set) was used to train a model to allow for a prediction,",
                              "given input available to a typical horse owner, to predict a likely outcome...basically a measure of good or bad where bad means death.",
                              "Details of how this model was created from the provided data can be found on the tab labeled ", em("Model Creation")," and the tab labeled ",
                              em("Help"), "is a request for any information on some free public data on Equine Laminitis (so please take a look)"),
                            p("Press the ",HTML("<b><i>Serverity Application</i></b>"), " tab at the top of this page to continue...")
                              
                    ),
                   tabPanel(title = "Serverity Application",
                        sidebarLayout(
                             sidebarPanel(
                                 selectInput('ageInput','Age',c('adult','young'),selected = 'adult'),
                                 numericInput('rect_tempInput','rectal temperature (celsius)',37.8,min=34,max=41,step=0.1),
                                 numericInput('pulseInput','Pulse (beats per minute)',35,min=30,max=190,step=1),
                                 numericInput('resp_rateInput','respiratory rate (per minute)',9,6,96),
                                 selectInput('extm_tempInput','temperature of extremities',c('Normal','Warm','Cool','Cold'), selected='Normal'),
                                 selectInput('periph_pulseInput','peripheral pulse',c('Normal','Increased','Reduced','Absent'),selected='Normal'),
                                 selectInput('muc_membInput','mucous membranes',c('Normal Pink','Bright Pink','Pale Pink','Pale Cyanotic','Bright Red','Dark Cyanotic'),selected='Normal Pink'),
                                 selectInput('cap_refilInput','capillary refill time',c('Less than 3 seconds','Greater or equal 3 seconds'),selected='Less than 3 seconds'),
                                 selectInput('painInput','Pain',c('no pain','depressed','intermittent mild pain','intermittent severe pain','continous severe pain'),selected='no pain'),
                                 selectInput('peristalsisInput','Peristalsis (Gut activity)',c('hypermotile','normal','hypomotile','absent'),selected='normal'),
                                 selectInput('abd_distInput','Abdominal Distension',c('none','slight','moderate','severe'),selected='none')
                                 
                                 
                             ),
                            mainPanel(
                                h2("Prognosis"),
                                h3("Confusion Matrix"),
                                p("this is a static result. The model was created off-line and results in the following matrix. Where 1=lives and 2=death"),
                                tableOutput('progOutput'),
                                h3("Prediction Results"),
                                p("this result is based on the prediction off the model (again, created off line) from your input on this page"),
                                h2(textOutput('predictOutput'),align="center"),
                                br(),
                                br(),
                                p("To see a change in the output, I suggest that you try the following:",
                                  HTML("<ol style='color:blue'>",
                                       "<li>increase respiratory rate to a maximum (say 46 or so)</li>",
                                       "<li>decreate temerature of extremities (to cool)</li>",
                                       "<li>change mucous membrans (bright red)</li>",
                                       "<li>increate pain (to a severe level)</li>",
                                       "</ol>"),
                                  "You might notice that as you change some of these settings to more severe measures, that the",
                                  "predictition might go from good to bad to good again...another indication of overfitting",
                                  style="color:blue"),
                                p("To reset these controls, just refresh the page in your browser (Next time I'll add a refresh or reset button)")
                            )
                        )
                   ),
                   
                   tabPanel(title = "Model Creation",
                       h3("Horse Colic Data Set"),
                       p("The UCI Machine Learning Repository contains a traing set that contains 300 observations of 27 features and one outcome.",
                         "They also provided a test set containing 68 observations. I used a subset of the features so as to limit the input to the application to only",
                         "those measurements that can be done by your typical horse owner (one that has a rectal thermomiter and the skill to take a capillary refill measurement)."),
                       p("The following data cleanup was done:"),
                       HTML("<ul>",
                            "<li> Removed unused columns for estimation modeling: Hospital ID, Surgery performed after the fact, factors only a doctor could perform, columns with >50% missing values</li>",
                            "<li> Replaced missing values with either average values from column or normal selection value (note: only 6 rows of data were complete so this had to be done)</li>",
                            "<li> Removed one observation from the traing data due to missing outcome (required for supervised learning)</li>",
                            "<li> The original data had 3 outcomes: lived, died, was euthanized. Since I only wished to know if lived or died, I adjusted the outcomes accordingly</li>",
                            "</ul>"
                            ),
                       p("Note that the model was not very accurate. In sample error was 99.8% but the out of sample error was about 75% indicating an over fitting of the model")
                   ),
                   
                   
                   tabPanel(title = "Help",
                       h3("A request for help"),
                       p("I'm looking for a public data set on ", HTML("<b><i>Equine Laminitis</i></b>"),". If anyone has information that can direct me to such a data set",
                         "would be of great help. I can be contacted via email at: ",HTML("<a href='mailto:pmpEL@pmconsult.com'>pmpEL@pmconsult.com</a>")),
                       p("I actually wanted this project to provide an application on this other rather nasty equine disease but I could not locate the data...and",
                         "yes I did have a horse succumb to this as well")
                   ))
)
