import collections
import sys
import os

# Technical Functions for merging, cutting , interlacing
def commonTags(f_tags,p_tags):
        allCommonWords=set(f_tags).union(set(p_tags))
        return sorted(allCommonWords)     

def kcut(Paintings,k):
    P1=Paintings[:k]
    P2=Paintings[k:]
    return P1,P2
    
def interlace(P1,P2):
    stop=False
    P=[]
    i=0
    while stop!=True:
        if i<len(P1):
            P.append(P1[i])
        if i<len(P2):
            P.append(P2[i])
        if i>=len(P1) and i>=len(P2):
            stop=True
        i+=1
    return P

def Interlacing_Reverse_Second(P1,P2):
    New_List =[]
    P2=P2[::-1]
    New_List =[val for pair in zip(P1, P2) for val in pair]
    if len(P1) > len(P2):
        New_List=New_List+P1[len(P2):]
    if len(P2) > len(P1):
        New_List= New_List+P2[len(P1):]
    return New_List

def mirrorJoin(F1,F2,mode=1):
    #losange 
    if mode==1:
        F1.sort(reverse=False)
        return F1+F2
    #valley
    if mode==2:
        F2.sort(reverse=False)
        return F1+F2

    #accordeon
    F1a,F1b=kcut(F1,len(F1)//2)
    F1b.sort(reverse=False)
    F2a,F2b=kcut(F2,len(F2)//2)
    F2b.sort(reverse=False)
    return F1a+F1b+F2a+F2b
    
def fragment(Frames):
    F1=[]
    F2=[]
    it=0
    for f in Frames:
        if it%2==0:
            F1.append(f)
        else:
            F2.append(f)
        it+=1
    return F1,F2

def couple_portraits(p1,p2):
    tags_number= len(set(p1.Tags).union(set(p2.Tags)))
    return tags_number 

def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

class Painting:

    ID = 0
    Type=""
    Tags=[]
    number_of_tags=-1

    def __init__(self,ID,p_Type,number_of_tags,p_tags):
        self.ID=ID
        self.Type=p_Type
        self.number_of_tags=number_of_tags
        self.Tags=p_tags
    
    # def __str__(self):
    #     return  "Paint ID:"+str(self.ID)+" ,Paint Type:"+ str(self.p_Type) +" ,T_Count:"+ str(self.number_of_tags)+" ,Tags:"+ str(self.Tags)

    
class Frame:
    ID=0
    number_of_tags=-1
    Tags=[]
    paintings = [None] * 2 # maximum 2 
    
    def __init__(self,ID):
        self.ID=ID
        self.Tags=[]
        self.paintings=[]
        self.number_of_tags=-1

    # def add_paint(self,painting):
    #     # at least one painting of type Landscape exist
    #     if len(self.paintings)==1:
    #         if painting.Type == 'L':
    #             return False
    #         if painting.Type=='P' and self.paintings[-1].Type=='L':
    #             return False
    #     # at least two painting of type portrait exist
    #     if len(self.paintings)==2:
    #         return False
    #     self.Tags =commonTags(self.Tags,painting.Tags)
    #     self.number_of_tags =len(self.Tags)
    #     self.paintings.append(painting)
    #     return True

    def add_paint(self,painting):

        # at least one painting of type Landscape exist
        self.Tags =commonTags(self.Tags,painting.Tags)
        self.number_of_tags =len(self.Tags)
        self.paintings.append(painting)
        return True


    def get_score(self,frame):
        A=self.Tags
        B=frame.Tags
        intersect=list(set(A).intersection(B))
        outA=list(set(A).difference(intersect))
        outB=list(set(B).difference(intersect))
        score=min(len(outA),len(intersect),len(outB))
        return score
                          

class Exhibition:
    # main attributes
    nb_paints=0
    paintings=[]
    frames=[]
    average_L_tags=0
    average_P_tags=0
    exhibition_score=0
    # meta attributes
    input=""
    unique_tags ={}
    unique_tags_dict={}
    unique_paint_dict={}
    unique_frame_dict ={}
    collisions_dict={}

    def __init__ (self, input_file):
        self.input=input_file
        self.nb_paints=input_file.readline()
        self.paintings=[]
        self.frames=[]    
        self.unique_tags=set([])
        self.unique_tags_dict={}
        self.unique_paint_dict={}
        self.unique_frame_dict ={}
        self.collisions_dict={}
        ID=0
        total_L_tags=0
        total_L_count=0
        total_P_tags=0
        total_P_count=0
        
        for line in input_file:
            # get line elements
            elements = line.split()
            p_type =elements[0].strip().upper()
            p_tag_count =elements[1].strip().upper()
            p_tags=elements[2:]

            # update dict of unique tags and add painting to list of paintings 
            self.unique_tags.update(p_tags)
            paint=Painting(ID,p_type,p_tag_count,p_tags)
            self.paintings.append(paint)

            if paint.Type == "L":
                total_L_tags+=int(paint.number_of_tags)
                total_L_count+=1
            if paint.Type == "P":
                total_P_tags+=int(paint.number_of_tags)
                total_P_count+=1
            ID+=1

        #initialize Dict of tags
        self.unique_tags_dict= dict.fromkeys(list(self.unique_tags),[])

        #calculate the averge of tags per type
        if total_L_count>0:
            self.average_L_tags=int(total_L_tags/total_L_count)

        if total_P_count>0:
            self.average_P_tags=int(total_P_tags/total_P_count)
       
  
    # firts naïve approach
    def first_fit(self):
        self.paintings.sort(key =lambda x : x.Type,reverse=False)
        ID=0
        for paint in self.paintings:
            # if list of frames is empty or the current frame is full 
            if len(self.frames)==0 or not self.frames[-1].add_paint(paint):
                #create a new frame
                frame= Frame(ID)
                ID+=1
                frame.add_paint(paint)
                self.frames.append(frame)
            else:
                # add to the last available frame 
                self.frames[-1].add_paint(paint)

    # Failed idea because of Complexity
    # def vectorize(self):
    # u need to put this in intint  #self.unique_tags_dict ={ i : 0 for i in self.unique_tags }
    #     st =""
    #     test = open("For_test.txt", "w")
    #     row_size = len(self.unique_tags_dict)
    #     column_size = len(self.paintings)
    #     st = st + str(row_size) +"X"+ str(column_size)+"\n"
    #     #print(row_size,column_size)
    #     vectors =[]
    #     #print(self.unique_tags_dict, "< master\n")
    #     st =st + str(self.unique_tags_dict) + " <--- master\n"
    #     for paint in self.paintings:
    #         vector = self.unique_tags_dict.copy()
    #         for tag in paint.Tags:
    #             vector[tag] = vector.get(tag) + 1
    #         #print(vector)
    #         vectors.append(list(vector.values()))  
        
    #     vectors= np.vstack(vectors)
    #     #print(vectors)
    
    # good idea badly performed not taking order of P's into consideraton
    def optimized_fit(self):
        st=""
        test = open("For_test.txt", "w")
        unique_tags_dict =self.unique_tags_dict.copy()
        row_size = len(unique_tags_dict)
        column_size = len(self.paintings)
        st+="\nmaster\n"
        st =st + str(unique_tags_dict) 
        st = st + str(row_size) +"X"+ str(column_size)+"\n"
        for paint in self.paintings:
            id = paint.ID
            for tag in paint.Tags:
                 unique_tags_dict[tag]= unique_tags_dict[tag]+[id]
        #print(unique_tags_dict)   
        st="-------\n\n"
        st+="\nTags dict filled\n"  
        st = st + str(unique_tags_dict)+"\n"     
        self.collisions_dict.clear()
        self.collisions_dict= {key:len(values) for (key,values) in unique_tags_dict.items()}
        self.collisions_dict =dict(sorted(self.collisions_dict.items(), key=lambda item: item[1]))
        #print(self.collisions_dict)
        st+="\nTags collision dict \n"  
        st = st + str(self.collisions_dict)+"\n"  

        List_of_collisions= list(set(x for x in self.collisions_dict.values()))
        List_of_collisions=sorted(List_of_collisions)
        #print(self.collisions_dict)
  
        #print(List_of_collisions)
        #self.unique_paint_dict = dict.fromkeys([range(0,len(self.paintings))],[])
        for paint in self.paintings:
            id = paint.ID
            number_original_tags = int(paint.number_of_tags)
            type= paint.Type
            tags =paint.Tags
            to_add=[tag for tag in tags if self.collisions_dict[tag]>1]
            to_add=sorted(to_add, key=lambda x: self.collisions_dict[x],reverse=True)
            self.unique_paint_dict[id]=[type,number_original_tags,to_add]
      
        #print(self.unique_paint_dict)
        st+="\nList of unique tags per picture \n" 
        st= st+ str(self.unique_paint_dict) +"\n"
        
        sorted_dict = dict(sorted(self.unique_paint_dict.items(), key=lambda x:(len(x[1][2]),x[1][1]-len(x[1][2])), reverse=True))

        print(sorted_dict)
        painnting_order=sorted_dict.keys()
        ID=0
        for paintID in painnting_order:
            # if list of frames is empty or the current frame is full 
            paint= self.paintings[paintID]
            if len(self.frames)==0 or not self.frames[-1].add_paint(paint):
                #create a new frame
                frame= Frame(ID)
                ID+=1
                frame.add_paint(paint)
                self.frames.append(frame)
            else:
                # add to the last available frame 
                self.frames[-1].add_paint(paint)
        st+="\nList_of_unique_number_collisions \n" 
        st = st + str(List_of_collisions)+"\n"  
        test.write(st)
        test.close()

    def optimized_fit_PL(self):

        st=""
        test = open("For_test.txt", "w")
        unique_tags_dict =self.unique_tags_dict.copy()
        st+="\nmaster\n"
        st =st + str(unique_tags_dict) 
        por = [paint for paint in self.paintings if paint.Type=="P"]
        Land = [paint for paint in self.paintings if paint.Type=="L"]
        for paint in por:
            id = paint.ID
            for tag in paint.Tags:
                 unique_tags_dict[tag]= unique_tags_dict[tag]+[id]
        #print(unique_tags_dict)   

        st="-------\n\n"
        st+="\nTags dict filled\n"  
        st = st + str(unique_tags_dict)+"\n"     
        self.collisions_dict.clear()
        self.collisions_dict= {key:len(values) for (key,values) in unique_tags_dict.items()}
        self.collisions_dict =dict(sorted(self.collisions_dict.items(), key=lambda item: item[1]))
        #print(self.collisions_dict)
        st+="\nTags collision dict \n"  
        st = st + str(self.collisions_dict)+"\n"  

        List_of_collisions= list(set(x for x in self.collisions_dict.values()))
        List_of_collisions=sorted(List_of_collisions)
        #print(self.collisions_dict)
  
        #print(List_of_collisions)
        #self.unique_paint_dict = dict.fromkeys([range(0,len(self.paintings))],[])
        for paint in por:
            id = paint.ID
            number_original_tags = int(paint.number_of_tags)
            type= paint.Type
            tags =paint.Tags
            to_add=[tag for tag in tags if self.collisions_dict[tag]>1]
            to_add=sorted(to_add, key=lambda x: self.collisions_dict[x],reverse=True)
            self.unique_paint_dict[id]=[type,number_original_tags,to_add]
      
        #print(self.unique_paint_dict)
        st+="\nList of unique tags per picture \n" 
        st= st+ str(self.unique_paint_dict) +"\n"
        
        sorted_dict = dict(sorted(self.unique_paint_dict.items(), key=lambda x:(len(x[1][2]),x[1][1]-len(x[1][2])), reverse=True))

        #print(sorted_dict)
        painting_order=sorted_dict.keys()
        #print(painting_order)
        ID=0
        for paintID in painting_order:
            # if list of frames is empty or the current frame is full 
            paint= self.paintings[paintID]
            if len(self.frames)==0 or not self.frames[-1].add_paint(paint):
                #create a new frame
                frame= Frame(ID)
                ID+=1
                frame.add_paint(paint)
                self.frames.append(frame)
            else:
                # add to the last available frame 
                self.frames[-1].add_paint(paint)

        for paint in Land:
            # if list of frames is empty or the current frame is full 
            if len(self.frames)==0 or self.frames[-1].add_paint(paint)==-1:
                #create a new frame
                frame= Frame(ID)
                ID+=1
                frame.add_paint(paint)
                self.frames.append(frame)
            else:
                # add to the last available frame 
                self.frames[-1].add_paint(paint)

        st+="\nList_of_unique_number_collisions \n" 
        st = st + str(List_of_collisions)+"\n"  
        test.write(st)
        test.close()


    def Best_PP(self):
    
        self.paintings = sorted(self.paintings, key=lambda x: x.number_of_tags,reverse=True)
        P_ordered_by_tags = [paint for paint in self.paintings if paint.Type=="P"]
        L_tags_order = [paint for paint in self.paintings if paint.Type=="L"]

        batch = int(len(P_ordered_by_tags) * 0.1)
        if batch<2:
            batch=2
        
        p_batch=[]
        p1,p2 =kcut(P_ordered_by_tags,len(P_ordered_by_tags)//2)
        P_ordered_by_tags =Interlacing_Reverse_Second(p2,p1)
        p1,p2 =kcut(P_ordered_by_tags,len(P_ordered_by_tags)//2)
        P_ordered_by_tags =Interlacing_Reverse_Second(p2,p1)
    

        all_batches=list(chunks(P_ordered_by_tags,batch))
        pp_list=[]
        left_from=[]
        for i in range(0,len(all_batches)):
            p_batch=all_batches[i]+left_from
            while len(p_batch)>1:
                for i in range(1,len(p_batch)):
                    p1=  p_batch[0]
                    p2 = p_batch[i]
                    score_temp = []
                    score_temp.append(couple_portraits(p1,p2))
                ind = score_temp.index(max(score_temp))+1
                p2_real = p_batch[ind]
                pp_list.append([p1.ID,p2_real.ID])
                p_batch.remove(p1)
                p_batch.remove(p2_real)
            left_from=p_batch
        # print(pp_list)
        # print(len(pp_list))
        # print(len(P_ordered_by_tags))
        frame_ID=0
        for [p1_index,p2_index] in pp_list:
          #create a new frame
                frame= Frame(frame_ID)
                frame_ID+=1
                frame.add_paint(self.paintings[p1_index])
                frame.add_paint(self.paintings[p2_index])
                self.frames.append(frame)
            
        for land in L_tags_order:
            #create a new frame
                frame= Frame(frame_ID)
                frame_ID+=1
                frame.add_paint(land)
                self.frames.append(frame)
        
    def Best_frames(self):

        self.frames = sorted(self.frames, key=lambda x: x.number_of_tags,reverse=True)

        ordered= self.frames.copy()
        batch = int(len(ordered) * 0.1)

        if batch<2:
            batch=2
        
        f_batch=[]

        all_batches=list(chunks(ordered,batch))
        frames_order=[]
        left_from=[]
        for i in range(0,len(all_batches)):
            f_batch=all_batches[i]+left_from
            while len(f_batch)>1:
                for i in range(1,len(f_batch)):
                    f1=  f_batch[0]
                    f2 = f_batch[i]
                    score_temp = []
                    score_temp.append(couple_portraits(f1,f2))
                ind = score_temp.index(min(score_temp))+1
                f2_real = f_batch[ind]
                frames_order.append(f1.ID)
                frames_order.append(f2_real.ID)
                f_batch.remove(f1)
                f_batch.remove(f2_real)
            left_from=f_batch

        # print(frames_order)
        # print(len(frames_order))
        # print(len(ordered))
    
        final_frames=[]
        for frameID in frames_order:
            final_frames.append(self.frames[frameID])
        self.frames=final_frames
       

    def fill_frames(self):

        portraits = [paint for paint in self.paintings if paint.Type=="P"]
        landscapes = [paint for paint in self.paintings if paint.Type=="L"]
        unique_tags_dict =self.unique_tags_dict.copy()
        
        for paint in portraits:
            id = paint.ID
            for tag in paint.Tags:
                 unique_tags_dict[tag]= unique_tags_dict[tag]+[id]

        self.collisions_dict.clear()
        self.collisions_dict= {key:len(values) for (key,values) in unique_tags_dict.items()}
        self.collisions_dict =dict(sorted(self.collisions_dict.items(), key=lambda item: item[1])) # item[1] is the value content corresponding to the key
        
        # asses collisions 
        List_of_collisions= list(set(x for x in self.collisions_dict.values()))
        List_of_collisions=sorted(List_of_collisions)

        for paint in portraits:
            id = paint.ID
            number_original_tags = int(paint.number_of_tags)
            type= paint.Type
            tags =paint.Tags
            to_add=[tag for tag in tags if self.collisions_dict[tag]>0] # only show tags that exist giving that the dict of unique tags is general ( P & L)
            to_add=sorted(to_add, key=lambda x: self.collisions_dict[x],reverse=True)
            self.unique_paint_dict[id]=[type,number_original_tags,to_add]

        sorted_dict = dict(sorted(self.unique_paint_dict.items(), key=lambda x:(len(x[1][2]),x[1][1]-len(x[1][2])), reverse=True))
       
        #print("sorted",sorted_dict)
        painting_order=list(sorted_dict.keys())
        #print("Order ",painting_order)
        # p1,p2 =kcut(painting_order,max(self.average_L_tags,self.average_P_tags))
        # painting_order=Interlacing_Reverse_Second(p1,p2)
        # p1,p2 =kcut(painting_order,max(self.average_L_tags,self.average_P_tags))
        p1,p2 =fragment(painting_order)
        painting_order=Interlacing_Reverse_Second(p1,p2)
        #print("cut, interlace",interlace(p1,p2))

        frame_ID=0
        for paintID in painting_order:
            # if list of frames is empty or the current frame is full 
            paint= self.paintings[paintID]
            if len(self.frames)==0 or not self.frames[-1].add_paint(paint):
                #create a new frame
                frame= Frame(frame_ID)
                frame_ID+=1
                frame.add_paint(paint)
                self.frames.append(frame)
            else:
                # add to the last available frame 
                self.frames[-1].add_paint(paint)

        for paint in landscapes:
            # if list of frames is empty or the current frame is full 
            if len(self.frames)==0 or not self.frames[-1].add_paint(paint):
                #create a new frame
                frame= Frame(frame_ID)
                frame_ID+=1
                frame.add_paint(paint)
                self.frames.append(frame)
            else:
                # add to the last available frame 
                self.frames[-1].add_paint(paint)
        
    def optimize_frames(self):
        unique_tags_dict=self.unique_tags_dict.copy()
        for frame in self.frames:
            id = frame.ID
            for tag in frame.Tags:
                 unique_tags_dict[tag]= unique_tags_dict[tag]+[id]
        # print(unique_tags_dict)   
        self.collisions_dict.clear()
        self.collisions_dict= {key:len(values) for (key,values) in unique_tags_dict.items()}
        self.collisions_dict =dict(sorted(self.collisions_dict.items(), key=lambda item: item[1]))

        # List_of_collisions= list(set(x for x in self.collisions_dict.values()))
        # List_of_collisions=sorted(List_of_collisions)
        #print(self.collisions_dict)
        #print(List_of_collisions)
        #self.unique_paint_dict = dict.fromkeys([range(0,len(self.paintings))],[])
        for frame in self.frames:
            id = frame.ID
            number_original_tags = int(frame.number_of_tags)
            tags =frame.Tags
            to_add=[tag for tag in tags if self.collisions_dict[tag]>0]
            to_add=sorted(to_add, key=lambda x: self.collisions_dict[x],reverse=True)
            self.unique_frame_dict[id]=[number_original_tags,to_add]

        sorted_dict = dict(sorted(self.unique_frame_dict.items(), key=lambda x:(len(x[1][1]),x[1][0]-len(x[1][1])), reverse=True))

        # test = open("For_test.txt", "w")
        # test.write(str(sorted_dict))
        # test.close()
        frames_order=list(sorted_dict.keys())
        #f1,f2 =kcut(frames_order,(self.average_L_tags+self.average_P_tags)//2)
        #frames_order =Interlacing_Reverse_Second(f2,f1)

        f1,f2 = fragment(frames_order)
        frames_order =mirrorJoin(f1,f2,1)

        #f1,f2 = kcut(frames_order,len(frames_order)//2)
        #frames_order =interlace(f1,f2)

        # f1,f2 =kcut(frames_order,len(frames_order)//2)
        # frames_order =Interlacing_Reverse_Second(f1,f2)

        # f1,f2 =kcut(frames_order,len(frames_order)//2)
        # frames_order =Interlacing_Reverse_Second(f1,f2)

        final_frames=[]
        for frameID in frames_order:
            final_frames.append(self.frames[frameID])
        self.frames=final_frames


    def export_output_file(self,output_file_path):
        try:
            output_file = open(output_file_path, "w")
            # write 
            output_string=str(len(self.frames))+"\n"
            for frame in self.frames:
                output_string+=" ".join([str(paint.ID) for paint in frame.paintings])+"\n"
            output_file.write(output_string)
            output_file.close()
        except IOError as e:
            print("An error occured while writing file. ",e.errno," - ",e)

    def get_total_score(self):
        self.exhibition_score=0
        for i in range(len(self.frames)-1):
            #print([paint.Type for paint in self.frames[i].paintings])
            self.exhibition_score+=self.frames[i].get_score(self.frames[i+1])
        #print([paint.Type for paint in self.frames[i+1].paintings])
        return self.exhibition_score
    

def main(input_file,output_file_path):
    exhibition= Exhibition(input_file)
    #exhibition.first_fit()
    #exhibition.vectorize()
    #exhibition.optimized_fit()
    #exhibition.optimized_fit_PL()
    #exhibition.fill_frames()
    #exhibition.optimize_frames()
    exhibition.Best_PP()
    exhibition.Best_frames()
    exhibition.export_output_file(output_file_path)
    return exhibition.get_total_score()
    

if __name__ == "__main__":
      try:
            input_file_path=sys.argv[1]
            output_file_path=sys.argv[2]
            file=open(input_file_path,'r')
            score=main(file,output_file_path)
            print("File Score :" ,score)
            file.close()
      except FileNotFoundError:
          print("Wrong file or file path")

    