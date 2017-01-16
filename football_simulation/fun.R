

# All the funciton used in Server.R :

# Load the  League data 2017 link http://www.football-data.co.uk/englandm.php

dat1 <- read.csv("Data/data.csv", stringsAsFactors = FALSE) %>%
    select("Home.Team"=HomeTeam,"Away.Team"=AwayTeam,
           "Home.Goal"=FTHG,"Away.Goal"=FTAG)

# reformating the data1

dat2 <- data.frame(Team=c(dat1$Home.Team,dat1$Away.Team),
                   Opponent = c(dat1$Away.Team,dat1$Home.Team),
                   Goals = c(dat1$Home.Goal,dat1$Away.Goal),
                   Home = c(rep(1,nrow(dat1)),rep(0,nrow(dat1))),
                   stringsAsFactors = FALSE)


# Function 1 take formated data, does poissn regression and then returns parameteres in as list for each team
# parameters are defense,attack and home advantage 
# Here the assumption is that goals have Poissson Distribution and goals scored by one team is independent of 
# another team goal---> this asumpption might not necessarily be true in real game

Parameters <- function(x) {
    model = glm(Goals ~ 0+Team+Opponent+Home,family=poisson,data=x)
    coeff = coefficients(model)
    teams = sort(unique(c(x[,1],x[,2])), decreasing = F)
    num = length(teams)
    home.parm = as.numeric(coeff[40])
    parameter = data.frame(row.names = make.names(teams),
                           Attack = c(coeff[(1:num)]),
                           Defense = c(0,coeff[(num+1):(2*num-1)]))
    return(list(teams=parameter,home=home.parm))
    
}


# Functon to calculate Mode, used to calculate expected goal for any team from the simulation result

Mode1 <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
}



# Function 3 *MAIN*
# This is the main function that takes any two team and simulates the game with using parameters
# function 'rpois' helps to simulate the game then graphs and other statistics are drawn from the simulaiton 

game_result <- function(H,A){
    
    #H = deparse(substitute(hometeam))
    #A = deparse(substitute(awayteam))
    parameter <- Parameters(dat2)
    h.attack = parameter$teams[H,1]
    h.defense = parameter$teams[H,2]
    a.attack = parameter$teams[A,1]
    a.defense = parameter$teams[A,2]
    home.parm = parameter$home
    hometeam_lam = exp(h.attack+a.defense+home.parm)
    awayteam_lam = exp(a.attack+h.defense)
    h_goal_sim = rpois(1000,hometeam_lam)
    a_goal_sim = rpois(1000,awayteam_lam)
    
    #cat("Expected Goal by",H[1],"is ",hometeam_lam,
    #    "\nExpected Goal by",A[1],"is ",round(awayteam_lam,5))
    
    h.goal = rpois(1,hometeam_lam)
    a.goal = rpois(1,awayteam_lam)
    
    # Find expected goals
    expectd_hgoal <<- Mode1(h.goal)
    expectd_agoal <<- Mode1(a.goal)
    
    
    
    homewin = sum(h_goal_sim>a_goal_sim)/1000
    awaywin = sum(a_goal_sim>h_goal_sim)/1000
    draw_game = sum(a_goal_sim==h_goal_sim)/1000
    game_wheel = data.frame("teams"=c("Homewin","Awaywin","Draw"), "Val"=c(homewin,awaywin,draw_game))
    
    
    
    #pie(game_wheel,cex=0.8,col=c("green","yellow","blue"))
    plot_pie <<- plot_ly(game_wheel,values = ~Val,labels = ~teams,
                 type= 'pie',
                 marker= list(colors=c("#FB6A4A", "#4292C6", "#74C476"),
                              line = list(color = '#FFFFFF', width = 1),
                              showlegend = FALSE)) %>%
                layout(title = 'Simulation Result',
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    
    
    graph_sim =data.frame(dens=c(h_goal_sim,a_goal_sim),
                          lines = rep(c(H,A),each=1000))
    
    # Graphs            
    final_graph1 <<- ggplot()+geom_bar(aes(x=h_goal_sim),stat="count",
                                    width = 1,color="white",fill=scales::alpha('red',.5))+
                    scale_x_discrete(name ="Simulated goals",limits=c(0:9))+
                    ggtitle(paste(H,"Goals"))+
                     theme_bw()+
                theme(axis.line = element_line(size=1, colour = "black"),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              plot.title=element_text(size = 20, family="xkcd-Regular"),
              text=element_text(size = 16, family="xkcd-Regular"),
              axis.text.x=element_text(colour="black", size = 12),
              axis.text.y=element_text(colour="black", size = 12))
    
    final_graph2 <<- ggplot()+geom_bar(aes(x=a_goal_sim),stat="count",
                                       width = 1,color="white",fill="skyblue")+
        scale_x_discrete(name ="Simulated goals",limits=c(0:9))+
        ggtitle(paste(A ,"Goals"))+
        theme_minimal()+
        theme(axis.line = element_line(size=1, colour = "black"),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              plot.title=element_text(size = 20, family="xkcd-Regular"),
              text=element_text(size = 16, family="xkcd-Regular"),
              axis.text.x=element_text(colour="black", size = 12),
              axis.text.y=element_text(colour="black", size = 12))
    
    
    
}
