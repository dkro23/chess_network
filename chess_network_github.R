
######
### Chess Network Analysis Project
### Github version
### Helpful sources in this project: 
### https://www.jessesadler.com/post/network-analysis-with-r/
### https://www.data-imaginist.com/2017/ggraph-introduction-edges/
#####

# Load packages

library(tidyverse)
library(igraph)
library(ggraph)

### Create network for chess starting position (for white)

# Create Edge list

protector<-c("ra1","ra1","nb1","bc1","bc1","q","q","q","q","q","k","k","k","k","k","bf1","bf1","ng1","rh1","rh1")
protectee<-c("a2","nb1","d2","b2","d2","bc1","c2","d2","e2","k","q","d2","e2","f2","bf1","e2","g2","e2","ng1","h2")

chess_edge_list<-as_tibble(cbind(protector,protectee))
chess_edge_list

# Create Node list

pieces<-c(unique(protectee),"ra1","rh1")
chess_node_list<-as_tibble(pieces)

chess_node_list <- chess_node_list %>% rowid_to_column("id")
chess_node_list

# Finish edge list (by replacing piece names with id labels)

chess_edge_list<-chess_edge_list %>% left_join(chess_node_list,by=c("protector"="value")) %>% rename(protect=id)
chess_edge_list<-chess_edge_list %>% left_join(chess_node_list,by=c("protectee"="value")) %>% rename(protected=id)
chess_edge_list

chess_edge_list<-chess_edge_list %>% select(protect, protected)
chess_edge_list

# Create network object

chess_network<-graph_from_data_frame(d=chess_edge_list,vertices = chess_node_list,directed = T)
summary(chess_network)
plot(chess_network)
plot(chess_network,mode="circle")

# Plot in ggraph

ggraph(chess_network) + geom_node_text(label=chess_node_list$value,size=5,repel = T) + geom_node_point(size=3) +
  geom_edge_link() +  geom_edge_link(arrow = arrow(length = unit(6, 'mm')), end_cap = circle(3, 'mm')) 
