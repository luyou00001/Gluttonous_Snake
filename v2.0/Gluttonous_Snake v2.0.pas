program Gluttonous_Snake;

uses sysutils,crt;

type maparray = array [1..50,1..50] of longint;

type maprecord = record
     x,y,startx,starty,sdirection,mrecord,t:longint;
     name,s:string;
     xy,area:maparray;
     passedge,passwall:Boolean;
end;

var i,j,k,l,choice,map_num,slength,score,speed,direction,enlarge,multiple,total,tx,ty,item_num:longint;
    itemx,itemy:array [1..5] of longint;
    timepass:array [1..4] of longint;
    choicestring:array [1..5] of string;
    map:array [0..24] of maprecord;
    die,pe,pw,acceleration:Boolean;
    snakex,snakey:array [1..9999] of longint;
    x,y,a:array [1..4] of word;
    infile,outfile:text;
    key:char; 

procedure ClearScreen;
var i:longint;
begin
     textbackground(8);
     for i:= 5 to 28 do
         begin
              gotoxy(21,i);
              write('                                                ');
         end;
end;

procedure AboutGame;
begin
     textbackground(7);
     textcolor(0);
     gotoxy(21,3);write('                 About the game                 ');
     ClearScreen;
     textbackground(8);
     textcolor(7);
     gotoxy(21,6);write('  Gluttonous Snake v2.0 by Sen Sen              ');
     gotoxy(21,7);write('  Collaborator: Kobe Li                         ');
     gotoxy(21,9);write('  My website:                                   ');
     gotoxy(21,10);write('  https://www.facebook.com/luyou001             ');
     gotoxy(21,12);write('  My email: luyou00001@gmail.com                ');
     gotoxy(21,14);write('  Welcome for suggestions!                      ');
     gotoxy(21,18);write('                     ********                   ');
     gotoxy(21,19);write('                     * ****                     ');
     gotoxy(21,20);write('                     ********                   ');
     gotoxy(21,21);write('                     * * * *                    ');
     gotoxy(21,22);write('                    *  ** *                     ');
     gotoxy(21,23);write('                   *   *    *                   ');
     gotoxy(21,27);write('                                   Press Enter  ');
     repeat
           key:=readkey;
     until key=#13;
end;

procedure EditMap;
begin
     textbackground(7);
     textcolor(0);
     gotoxy(21,3);write('                   Map Editer                   ');
     ClearScreen;
     textbackground(8);
     textcolor(7);
     gotoxy(21,6);write('  Not finished ... Please wait for v2.1 ...     ');
     gotoxy(21,27);write('                                   Press Enter  ');
     repeat
           key:=readkey;
     until key=#13;
end;

procedure DrawSun;
var i:longint;
begin              
     textbackground(8);
     textcolor(7);
     for i:= 2 to 28 do
         begin                        
              gotoxy(3,i);write('                ');
              gotoxy(71,i);write('                ');
         end;
     textbackground(7);
     textcolor(0);
     for i:= 1 to 7 do
         begin
              gotoxy(3,4+i);write('                ');
              gotoxy(71,4+i);write('                ');
              gotoxy(3,18+i);write('                ');
              gotoxy(71,18+i);write('                ');
         end;
     for i:= 0 to 1 do
         begin
              textbackground(8);
              textcolor(7);
              gotoxy(6+68*i,6);write('         :');
              gotoxy(6+68*i,7);write('  ');
              gotoxy(6+68*i,8);write('          ');
              gotoxy(14+68*i,9);write('  ');
              gotoxy(6+68*i,10);write('          ');
              textbackground(7);
              textcolor(0);
              gotoxy(6+68*i,13);write('  ');
              gotoxy(6+68*i,14);write('  ');
              gotoxy(6+68*i,15);write('  ');
              gotoxy(6+68*i,16);write('  ');
              gotoxy(6+68*i,17);write('          ');
              gotoxy(14+68*i,13);write('''''');
              gotoxy(14+68*i,14);write('  ');
              gotoxy(14+68*i,15);write('  ');
              gotoxy(14+68*i,16);write('  ');
              textbackground(8);
              textcolor(7);
              gotoxy(6+68*i,20);write('    ');
              gotoxy(14+68*i,20);write('  ');
              gotoxy(6+68*i,21);write('      ');
              gotoxy(14+68*i,21);write('  ');
              gotoxy(6+68*i,22);write('  ');
              gotoxy(10+68*i,22);write('  ');
              gotoxy(14+68*i,22);write('  ');
              gotoxy(6+68*i,23);write('  ');
              gotoxy(10+68*i,23);write('      ');
              gotoxy(6+68*i,24);write('..');
              gotoxy(12+68*i,24);write('    ');
         end;
     gotoxy(3,3);write('    SUN CHOI    ');
     gotoxy(71,3);write('    SUN CHOI    ');
     gotoxy(3,27);write('    SUN CHOI    ');
     gotoxy(71,27);write('    SUN CHOI    ');
end;

procedure DrawFrame;
var i:longint;
begin
     textbackground(8);
     textcolor(7);
     gotoxy(21,3);write('       Gluttonous Snake v2.0  by SUN CHOI       ');
     gotoxy(1,1);
     textbackground(11);
     for i:= 1 to 88 do write(' ');
     gotoxy(1,29);
     for i:= 1 to 88 do write(' ');
     gotoxy(21,4);
     for i:= 1 to 48 do write(' ');
     for i:= 2 to 28 do
         begin
              gotoxy(1,i);write('  ');
              gotoxy(19,i);write('  ');
              gotoxy(69,i);write('  ');
              gotoxy(87,i);write('  ');
         end;
end;   

procedure ShowSnake;
begin
     for i:= 2 to slength do
         begin
              if acceleration then textbackground(4)
                 else if map[map_num].xy[snakex[i],snakey[i]]=1 then textbackground(8)
                      else textbackground(7);
              gotoxy(snakex[i]*2+19,snakey[i]+4);write('  ');
         end;
     if acceleration then textbackground(4)
        else if map[map_num].xy[snakex[1],snakey[1]]=1 then textbackground(8)
             else textbackground(7);
     if map[map_num].xy[snakex[1],snakey[1]]=1 then textcolor(7)
        else textcolor(0);
     gotoxy(snakex[1]*2+19,snakey[1]+4);
     case direction of  
     1:write('''''');
     2:write('..');
     3:write(': ');
     4:write(' :');
     end;
end;

procedure ShowInfo;
begin
     textbackground(8);
     textcolor(7);
     gotoxy(71,4);write('       0        ');
     if map_num>=10 then gotoxy(78,4)
        else gotoxy(79,4);
     write(map_num);
     gotoxy(71,5);write('                ');
     gotoxy(71+(16-length(map[map_num].name)) div 2,5);write(map[map_num].name);
     textbackground(7);
     textcolor(0);
     gotoxy(71,9);write('    00000000    ');
     case map[map_num].mrecord of
     0..9:gotoxy(82,9);
     10..99:gotoxy(81,9);
     100..999:gotoxy(80,9);
     1000..9999:gotoxy(79,9);
     10000..99999:gotoxy(78,9);
     100000..999999:gotoxy(77,9);
     1000000..9999999:gotoxy(76,9);
     else gotoxy(75,9);
     end;
     pe:=map[map_num].passedge;
     pw:=map[map_num].passwall;
     write(map[map_num].mrecord);
     textbackground(8);
     textcolor(7);
     gotoxy(82,12);
     if pe then write('on ')
        else write('off');
     gotoxy(82,13);
     if pw then write('on ')
        else write('off');
     ClearScreen;
     for i:= 1 to 24 do
         for j:= 1 to 24 do
             begin
                  textbackground(7);
                  gotoxy(i*2+19,j+4);
                  if map[map_num].xy[i,j]=1 then write('  ');
             end;
     {for i:= 1 to 24 do                //show area
         for j:= 1 to 24 do
             begin
                  if map[map_num].xy[i,j]=1 then textcolor(0)
                     else textcolor(7);
                  if map[map_num].xy[i,j]=1 then textbackground(7)
                     else textbackground(8);
                  gotoxy(i*2+19,j+4);write(map[map_num].area[i,j],map[map_num].area[i,j]);
             end;}
     with map[map_num] do
          begin
               direction:=sdirection;
               case direction of
               1:
                 for i:= 1 to 6 do
                     begin
                          snakex[i]:=startx;
                          snakey[i]:=starty-1+i;
                     end;
               2:
                 for i:= 1 to 6 do
                     begin
                          snakex[i]:=startx;
                          snakey[i]:=starty+1-i;
                     end;
               3:
                 for i:= 1 to 6 do
                     begin
                          snakex[i]:=startx-1+i;
                          snakey[i]:=starty;
                     end;
               4:
                 for i:= 1 to 6 do
                     begin
                          snakex[i]:=startx+1-i;
                          snakey[i]:=starty;
                     end;
               end;
          end;
     ShowSnake;
end;

procedure ShowScore;
begin
     textbackground(7);
     textcolor(0);
     gotoxy(71,8);write('    00000000    ');
     case score of
     0..9:gotoxy(82,8);
     10..99:gotoxy(81,8);
     100..999:gotoxy(80,8);
     1000..9999:gotoxy(79,8);
     10000..99999:gotoxy(78,8);
     100000..999999:gotoxy(77,8);
     1000000..9999999:gotoxy(76,8);
     else gotoxy(75,8);
     end;
     write(score);
     if score>map[map_num].mrecord then
        begin
             gotoxy(71,10);write('    00000000    ');
             case score of
             0..9:gotoxy(82,10);
             10..99:gotoxy(81,10);
             100..999:gotoxy(80,10);
             1000..9999:gotoxy(79,10);
             10000..99999:gotoxy(78,10);
             100000..999999:gotoxy(77,10);
             1000000..9999999:gotoxy(76,10);
             else gotoxy(75,10);
             end;
             write(score);
        end;
end;

procedure GenItem(num:longint);
var tx,ty:longint;
    onsnake,onitem:Boolean;
begin
     repeat
           tx:=random(map[map_num].x)+1;
           ty:=random(map[map_num].y)+1;
           onsnake:=False;
           onitem:=False;
           for i:= 1 to slength do
               if (snakex[i]=tx) and (snakey[i]=ty) then onsnake:=True;
           for i:= 1 to 5 do
               if (itemx[i]=tx) and (itemy[i]=ty) then onitem:=True;
     until (onsnake=False) and (onitem=False) and (pw or ((pw=False) and (map[map_num].area[tx,ty]=1)));
     itemx[num]:=tx;
     itemy[num]:=ty;
     gotoxy(itemx[num]*2+19,itemy[num]+4);
     case num of
     1:textbackground(2);
     2:textbackground(6);
     3:textbackground(4);
     4:textbackground(1);
     5:textbackground(5);
     end;
     if map[map_num].area[tx,ty]<>map[map_num].area[snakex[1],snakey[1]] then
        begin
             if map[map_num].xy[tx,ty]=1 then textcolor(7)
                else textcolor(0);
             write('><');
        end
        else write('  ');
end;

procedure ClearSnake;
begin
     for i:= slength downto 1 do
         begin
              gotoxy(snakex[i]*2+19,snakey[i]+4);
              if map[map_num].xy[snakex[i],snakey[i]]=1 then textbackground(7)
                 else textbackground(8);
              write('  ');
         end;
end;   

function Full(map:maprecord):Boolean;
var i,j:longint;
begin
     Full:=True;
     for i:= 1 to map.x do
         for j:= 1 to map.y do
             if map.area[i,j]<0 then Full:=False;
end;

procedure SetArea(var map:maprecord;x,y,sx,sy,area:longint);
var tx,ty:longint;
begin
     if map.xy[x,y]=map.xy[sx,sy] then map.area[x,y]:=area;
     if map.area[x,y]=area then
        begin
             tx:=x;
             ty:=y-1;
             if (ty=0) and map.passedge then ty:=map.y;
             if (map.area[tx,ty]<>area) and (ty>0) then SetArea(map,tx,ty,sx,sy,area);
             ty:=y+1;
             if (ty=map.y+1) and map.passedge then ty:=1;
             if (map.area[tx,ty]<>area) and (ty<map.y+1) then SetArea(map,tx,ty,sx,sy,area);
             tx:=x-1;
             ty:=y;
             if (tx=0) and map.passedge then tx:=map.x;
             if (map.area[tx,ty]<>area) and (tx>0) then SetArea(map,tx,ty,sx,sy,area);
             tx:=x+1;
             if (tx=map.x+1) and map.passedge then tx:=1;
             if (map.area[tx,ty]<>area) and (tx<map.x+1) then SetArea(map,tx,ty,sx,sy,area);
        end;
end; 

procedure ReadData;
begin
     textbackground(8);
     textcolor(7);
     ClearScreen;
     gotoxy(21,13);write('                   Loading...                   ');
     assign(infile,'map.txt');
     reset(infile);
     total:=-1;
     while (not EOF(infile)) and (total<24) do
           begin
                total:=total+1;
                with map[total] do
                     begin
                          readln(infile,name);
                          readln(infile,x);
                          readln(infile,y);
                          readln(infile,mrecord);
                          readln(infile,t);
                          if t=1 then passedge:=True else passedge:=False;
                          readln(infile,t);
                          if t=1 then passwall:=True else passwall:=False;
                          for i:= 1 to 50 do
                              for j:= 1 to 50 do xy[i,j]:=-1;
                          for i:= 1 to y do
                              begin
                                   readln(infile,s);
                                   for j:= 1 to x do xy[j,i]:=ord(s[j])-48;
                              end;
                          readln(infile,startx);
                          readln(infile,starty);
                          readln(infile,sdirection);
                          readln(infile);
                     end;
           end;
     close(infile);
     for i:= 0 to 24 do
         for j:= 1 to 50 do
             for k:= 1 to 50 do map[i].area[j,k]:=-1;
     for i:= 0 to total do
         begin
              j:=0;
              repeat
                    j:=j+1;
                    if j=1 then
                       begin
                            tx:=map[i].startx;
                            ty:=map[i].starty;
                       end
                          else
                              for k:= map[i].x downto 1 do
                                  for l:= map[i].y downto 1 do
                                      if map[i].area[k,l]<0 then
                                         begin
                                              tx:=k;
                                              ty:=l;
                                         end;
                    Setarea(map[i],tx,ty,tx,ty,j);
              until Full(map[i]);
         end;
end;

procedure SaveData;
begin
     ClearScreen;
     gotoxy(21,13);write('                   Loading...                   ');
     assign(outfile,'map.txt');
     rewrite(outfile);
     for i:= 0 to total do
         with map[i] do
              begin
                   writeln(outfile,name);
                   writeln(outfile,x);
                   writeln(outfile,y);
                   if (i=map_num) and (score>mrecord) then writeln(outfile,score)
                      else writeln(outfile,mrecord);
                   if passedge then writeln(outfile,'1')
                      else writeln(outfile,'0');
                   if passwall then writeln(outfile,'1')
                      else writeln(outfile,'0');
                   for k:= 1 to y do
                       begin
                            for j:= 1 to x do write(outfile,xy[j,k]);
                            writeln(outfile);
                       end;
                   writeln(outfile,startx);
                   writeln(outfile,starty);
                   writeln(outfile,sdirection);
                   if i<total then writeln(outfile);
              end;
     close(outfile);
end;

procedure GameOver;
begin
     ClearSnake;
     delay(200);
     ShowSnake;
     delay(200);
     ClearSnake;
     delay(200);
     ShowSnake;
     delay(200);
     ClearSnake;
     delay(200);
     ShowSnake;
     delay(150);
     for i:= slength downto 1 do
         begin
              delay(50);
              gotoxy(snakex[i]*2+19,snakey[i]+4);
              if map[map_num].xy[snakex[i],snakey[i]]=1 then textbackground(7)
                 else textbackground(8);
              write('  ');
              if slength-i+1>6 then
                 begin
                      if acceleration then score:=score+(slength-i+1)*speed div 10
                         else score:=score+(slength-i+1)*speed div 5;
                      ShowScore;
                 end;
         end;
     delay(1000);
     DrawSun;
     ClearScreen;
     textbackground(7);
     for i:= 12 to 18 do
         begin
              gotoxy(21,i);write('                                                ');
         end;
     for i:= 23 to 25 do
         begin
              gotoxy(21,i);write('                                                ');
         end;
     gotoxy(22,6);write('          ');
     gotoxy(34,6);write('          ');
     gotoxy(46,6);write('    ');
     gotoxy(52,6);write('    ');
     gotoxy(58,6);write('          ');
     gotoxy(22,7);write('  ');
     gotoxy(34,7);write('  ');
     gotoxy(42,7);write('  ');
     gotoxy(46,7);write('          ');
     gotoxy(58,7);write('  ');
     gotoxy(22,8);write('  ');
     gotoxy(26,8);write('      ');    
     gotoxy(34,8);write('          '); 
     gotoxy(46,8);write('  ');
     gotoxy(50,8);write('  ');
     gotoxy(54,8);write('  ');
     gotoxy(58,8);write('          '); 
     gotoxy(22,9);write('  ');
     gotoxy(30,9);write('  ');
     gotoxy(34,9);write('  ');
     gotoxy(42,9);write('  ');
     gotoxy(46,9);write('  ');
     gotoxy(54,9);write('  ');
     gotoxy(58,9);write('  ');       
     gotoxy(22,10);write('          ');
     gotoxy(34,10);write('  ');
     gotoxy(42,10);write('  ');
     gotoxy(46,10);write('  ');
     gotoxy(54,10);write('  ');
     gotoxy(58,10);write('          ');
     textbackground(8);     //22,34,46,58
     gotoxy(22,13);write('          ');
     gotoxy(34,13);write('  ');
     gotoxy(42,13);write('  ');
     gotoxy(46,13);write('          ');
     gotoxy(58,13);write('          ');
     gotoxy(22,14);write('  ');
     gotoxy(30,14);write('  ');
     gotoxy(34,14);write('  ');
     gotoxy(42,14);write('  ');
     gotoxy(46,14);write('  ');
     gotoxy(58,14);write('  ');
     gotoxy(66,14);write('  ');
     gotoxy(22,15);write('  ');
     gotoxy(30,15);write('  ');
     gotoxy(34,15);write('    ');
     gotoxy(40,15);write('    ');
     gotoxy(46,15);write('          ');
     gotoxy(58,15);write('          ');
     gotoxy(22,16);write('  ');
     gotoxy(30,16);write('  ');
     gotoxy(36,16);write('      ');
     gotoxy(46,16);write('  ');
     gotoxy(58,16);write('  ');
     gotoxy(62,16);write('  ');
     gotoxy(22,17);write('          ');
     gotoxy(38,17);write('  ');   
     gotoxy(46,17);write('          ');
     gotoxy(58,17);write('  ');
     gotoxy(62,17);write('      ');
     textcolor(7);
     gotoxy(23,20);write('Map 0'); 
     if map_num>=10 then gotoxy(27,20)
        else gotoxy(28,20);
     write(map_num);
     gotoxy(23,21);write(map[map_num].name);
     gotoxy(39,20);write('Score:',score);
     if score>map[map_num].mrecord then write(' New record!');
     gotoxy(39,21);write('Best Record:');
     if score>map[map_num].mrecord then write(score)
        else write(map[map_num].mrecord);
     gotoxy(21,27);write('                                   Press Enter  ');
     textbackground(7);
     textcolor(0);
     gotoxy(23,24);write('Speed:');
     if acceleration then write(speed div 2)
        else write(speed);
     gotoxy(35,24);write('Final Length:',slength);
     gotoxy(53,24);write('Multiple:',multiple);
     while keypressed do
           key:=readkey;
     repeat
           key:=readkey;
     until key=#13;
     SaveData;  
     ReadData;
end;

procedure SnakeMove(tx,ty:longint);
var t1,t2,t3:Boolean;
begin       
     t1:=False;
     t2:=False;
     t3:=False;
     if (itemx[1]=tx) and (itemy[1]=ty) then
        begin
             enlarge:=enlarge+1;
             score:=score+((multiple+5)*(1000+speed) div 10);
             if acceleration then multiple:=multiple+2
                else multiple:=multiple+1;
             t1:=True;
             ShowScore;
             textbackground(7);
             if acceleration then textcolor(12)
                else textcolor(0);
             gotoxy(81,23);write(multiple,' ');
        end;
     if (itemx[2]=tx) and (itemy[2]=ty) then
        begin
             score:=score+((multiple+5)*(1000+speed) div 2);
             if acceleration then multiple:=multiple+6
                else multiple:=multiple+3;
             t2:=True;
             ShowScore;
             textbackground(7);
             if acceleration then textcolor(12)
                else textcolor(0);
             gotoxy(81,23);write(multiple,' ');
        end;
     if (itemx[3]=tx) and (itemy[3]=ty) then
        begin
             acceleration:=True;
             speed:=speed*2;
             multiple:=multiple*2;
             pw:=False;
             textbackground(8);
             textcolor(12);
             gotoxy(82,14);write('off');
             textbackground(7);
             gotoxy(78,17);write(speed,' ');
             gotoxy(81,23);write(multiple,' ');
             timepass[2]:=0;
             timepass[4]:=0;
             t2:=True;      
             DecodeTime(time,a[1],a[2],a[3],a[4]);
        end;       
     if (itemx[4]=tx) and (itemy[4]=ty) then
        begin
             enlarge:=enlarge+5;
             t2:=True;
        end;
     if (itemx[5]=tx) and (itemy[5]=ty) then
        begin
             t2:=True;
             t3:=True;
        end;
     if die=False then
        begin
             if enlarge=0 then
                begin     
                     gotoxy(snakex[slength]*2+19,snakey[slength]+4);
                     if map[map_num].xy[snakex[slength],snakey[slength]]=1 then textbackground(7)
                        else textbackground(8);
                     write('  ');
                     for i:= slength downto 2 do
                         begin
                              snakex[i]:=snakex[i-1];
                              snakey[i]:=snakey[i-1];
                         end;
                     snakex[1]:=tx;
                     snakey[1]:=ty;
                end;
             if enlarge>0 then
                begin
                     for i:= slength+1 downto 2 do
                         begin
                              snakex[i]:=snakex[i-1];
                              snakey[i]:=snakey[i-1];
                         end;   
                     snakex[1]:=tx;
                     snakey[1]:=ty;
                     slength:=slength+1;
                     enlarge:=enlarge-1;
                     textbackground(8);
                     textcolor(7);
                     gotoxy(79,20);write(slength,' ');
                end;
             if enlarge<0 then
                begin    
                     tx:=snakex[slength];
                     ty:=snakey[slength];
                     snakex[slength]:=-1;
                     snakey[slength]:=-1;
                     gotoxy(tx*2+19,ty+4);
                     if map[map_num].xy[tx,ty]=1 then textbackground(7)
                        else textbackground(8);
                     write('  ');
                     slength:=slength-1;
                     enlarge:=enlarge+1;
                     textbackground(8);
                     textcolor(7);
                     gotoxy(79,20);write(slength,' ');
                end;
             ShowSnake;
        end;
     if t1 then GenItem(1);
     if t2 then
        for i:= 2 to 5 do
            begin
                 itemx[i]:=-1;
                 itemy[i]:=-1;
            end;
     if t3 then enlarge:=enlarge-5;
end;

procedure ChangeDirection;
var tx,ty:longint;
begin
     tx:=snakex[1];
     ty:=snakey[1];
     case direction of
     1:
       begin
            ty:=snakey[1]-1;
            if (ty=0) and pe then ty:=map[map_num].y
               else if (ty=0) and (enlarge>=0) then die:=True;
       end;
     2:
       begin
            ty:=snakey[1]+1;
            if (ty=map[map_num].y+1) and pe then ty:=1
               else if (ty=map[map_num].y+1) and (enlarge>=0) then die:=True;
       end;
     3:
       begin
            tx:=snakex[1]-1;
            if (tx=0) and pe then tx:=map[map_num].x
               else if (tx=0) and (enlarge>=0) then die:=True;
       end;
     4:
       begin
            tx:=snakex[1]+1;
            if (tx=map[map_num].x+1) and pe then tx:=1
               else if (tx=map[map_num].x+1) and (enlarge>=0) then die:=True;
       end;
     end;
     if die then
        begin
             gotoxy(1,1);write('haha');
        end;
     if (map[map_num].xy[tx,ty]<>map[map_num].xy[snakex[1],snakey[1]]) and (enlarge>=0) then die:=True;
     for i:= 1 to slength do
         if (snakex[i]=tx) and (snakey[i]=ty) and (enlarge>=0) then die:=True;
     if die=False then SnakeMove(tx,ty);
end;

procedure PassWall;
var temp,tx,ty:longint;
    pass:Boolean;
begin
     pass:=False;
     direction:=direction-4;
     tx:=snakex[1];
     ty:=snakey[1];
     case direction of
     1..2:
          begin
               temp:=snakex[1]-1;
               if temp=0 then temp:=map[map_num].x;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[temp,ty] then
                  begin
                       direction:=3;
                       tx:=temp;
                       pass:=True;
                  end;
               temp:=snakex[1]+1;
               if temp=map[map_num].x+1 then temp:=1;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[temp,ty] then
                  begin      
                       direction:=4;
                       tx:=temp;
                       pass:=True;
                  end;
          end;
     3..4:
          begin
               temp:=snakey[1]-1;
               if temp=0 then temp:=map[map_num].y;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[tx,temp] then
                  begin           
                       direction:=1;
                       ty:=temp;
                       pass:=True;
                  end;
               temp:=snakey[1]+1;
               if temp=map[map_num].x+1 then temp:=1;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[tx,temp] then
                  begin         
                       direction:=2;
                       ty:=temp;
                       pass:=True;
                  end;
          end;
     end;
     if pass then
        begin
             for i:= 1 to slength do
                 if (snakex[i]=tx) and (snakey[i]=ty) and (enlarge>=0) then die:=True;
             if die=False then
                begin
                     SnakeMove(tx,ty);
                     for i:= 1 to 5 do
                         if itemx[i]>0 then
                            begin
                                 tx:=itemx[i];
                                 ty:=itemy[i];
                                 gotoxy(tx*2+19,ty+4);
                                 case i of
                                 1:textbackground(2);
                                 2:textbackground(6);
                                 3:textbackground(4);
                                 4:textbackground(1);
                                 5:textbackground(5);
                                 end;
                                 if map[map_num].area[tx,ty]<>map[map_num].area[snakex[1],snakey[1]] then
                                    begin
                                         if map[map_num].xy[tx,ty]=1 then textcolor(7)
                                            else textcolor(0);
                                         write('><');
                                    end
                                    else write('  ');
                            end;
                 end;
        end
        else ChangeDirection;
end;

function NoItem:Boolean;
begin
     NoItem:=True;
     for i:= 2 to 5 do
         if itemx[i]>0 then NoItem:=False;
end;

procedure Action;
begin
     timepass[3]:=0;
     timepass[4]:=0;
     GenItem(1);
     DecodeTime(time,x[1],x[2],x[3],x[4]);
     DecodeTime(time,a[1],a[2],a[3],a[4]);
     repeat      
           DecodeTime(time,y[1],y[2],y[3],y[4]);
           timepass[1]:=(y[1]-x[1])*3600000+(y[2]-x[2])*60000+(y[3]-x[3])*1000+(y[4]-x[4]);
           timepass[2]:=(y[1]-a[1])*3600000+(y[2]-a[2])*60000+(y[3]-a[3])*1000+(y[4]-a[4]);
           if keypressed then key:=readkey;             
           if timepass[1]+timepass[3]>=50000 div speed then
              begin
                   if (enlarge>=0) and (key<>'') then
                      begin
                           if (key=#72) and (direction<>2) then direction:=1;
                           if (key=#80) and (direction<>1) then direction:=2;
                           if (key=#75) and (direction<>4) then direction:=3;
                           if (key=#77) and (direction<>3) then direction:=4;
                           if (key=#120) and pw then direction:=direction+4;
                           key:=' ';
                      end;
                   timepass[3]:=0;
                   if direction<5 then ChangeDirection
                      else PassWall;
                   {textbackground(11);  //show coordinates of head
                   gotoxy(1,1);write('(',snakex[1],',',snakey[1],')        ');}
                   DecodeTime(time,x[1],x[2],x[3],x[4]);
              end;
           if NoItem and (acceleration=False) then
              begin
                   item_num:=random(2500000)+2;
                   if ((item_num<6) and (slength>5)) or ((item_num<5) and (slength<=5)) then
                      begin
                           GenItem(item_num);
                           DecodeTime(time,a[1],a[2],a[3],a[4]);
                           timepass[4]:=0;
                      end;
              end;
           if key=#112 then
              begin
                   timepass[3]:=timepass[1];
                   timepass[4]:=timepass[2];
                   textbackground(7);
                   textcolor(0);
                   gotoxy(21,3);write('    Pause... Press the arrow key to continue    ');
                   repeat
                         key:=readkey;
                   until ((key=#72) and (direction<>2)) or ((key=#80) and (direction<>1)) or ((key=#75) and (direction<>4)) or ((key=#77) and (direction<>3)) or (key=#27);
                   gotoxy(21,3);write('                    Play  Mode                  ');
                   DecodeTime(time,x[1],x[2],x[3],x[4]); 
                   DecodeTime(time,a[1],a[2],a[3],a[4]);
              end;
           if (timepass[2]+timepass[4]>=10000) and (NoItem=False) then
              begin                 
                   for i:= 2 to 5 do
                       if itemx[i]>0 then
                           begin
                                gotoxy(itemx[i]*2+19,itemy[i]+4);
                                if map[map_num].xy[itemx[i],itemy[i]]=1 then textbackground(7)
                                   else textbackground(8);
                                write('  ');
                           end;
                   for i:= 2 to 5 do
                       begin
                            itemx[i]:=-1;
                            itemy[i]:=-1;
                       end;
              end;
           if (timepass[2]+timepass[4]>=5000) and acceleration then
              begin                 
                   acceleration:=False;
                   speed:=speed div 2;
                   multiple:=multiple div 2;
                   pw:=map[map_num].passwall;          
                   textbackground(8);
                   textcolor(7);
                   gotoxy(82,14);write('off');
                   textbackground(7);
                   textcolor(0);
                   gotoxy(78,17);write(speed,' ');
                   gotoxy(81,23);write(multiple,' ');
              end;
     until die or (key=#27);
     if die then GameOver;
     if acceleration then speed:=speed div 2;
end;

procedure PlayMode;
begin
     textbackground(7);
     textcolor(0);
     gotoxy(21,3);write('                   Play  Mode                   ');
     textbackground(8);
     for i:= 2 to 28 do
         begin
              gotoxy(3,i);write('                ');
              gotoxy(71,i);write('                ');
         end;    
     textbackground(7);
     for i:= 7 to 10 do
         begin
              gotoxy(71,i);write('                ');
         end;
     for i:= 8 to 12 do
         begin
              gotoxy(3,i);write('                ');
         end;
     for i:= 18 to 20 do
         begin
              gotoxy(3,i);write('                ');
         end;
     for i:= 24 to 28 do
         begin
              gotoxy(3,i);write('                ');
         end;
     textbackground(2);
     gotoxy(4,3);write('  ');
     textbackground(6);
     gotoxy(4,9);write('  ');
     textbackground(4);
     gotoxy(4,14);write('  ');
     textbackground(1);
     gotoxy(4,19);write('  ');
     textbackground(5);
     gotoxy(4,22);write('  ');
     textbackground(8);
     textcolor(7);
     gotoxy(7,3);write('Food');
     gotoxy(4,4);write('+Few Scores');
     gotoxy(4,5);write('Length+1');
     gotoxy(4,6);write('Multiple+1');
     gotoxy(7,14);write('Multiple*2');
     gotoxy(4,15);write('Pass Wall:off');
     gotoxy(4,16);write('Speed*2 (5s)');
     gotoxy(7,22);write('length-5');
     gotoxy(71,3);write(' Choose Map(+-) ');
     gotoxy(71,12);write(' Pass Edge:     ');
     gotoxy(71,13);write(' Pass Wall:     ');
     textbackground(7);
     textcolor(0);            
     gotoxy(71,8);write('  Best  Record  ');
     gotoxy(7,9);write('Treasure');
     gotoxy(4,10);write('+many scores');
     gotoxy(4,11);write('multiple+3');
     gotoxy(7,19);write('length+5');
     gotoxy(4,25);write('[Arrow Keys]:');
     gotoxy(4,26);write('Move/Continue');
     gotoxy(4,27);write('[X]:Pass Wall');
     slength:=6;
     enlarge:=0;
     acceleration:=False;
     multiple:=1;
     die:=False;
     ShowInfo;
     repeat
           key:=readkey;
           if (key=#43) and (map_num<total) then
              begin
                   map_num:=map_num+1;
                   ShowInfo;
              end;
           if (key=#45) and (map_num>0) then
              begin
                   map_num:=map_num-1;
                   ShowInfo;
              end;
     until (key=#13) or (key=#27);
     if key=#13 then
        begin            
             textbackground(8);
             textcolor(7);
             gotoxy(71,3);write ('     Map 0      ');
             if map_num>=10 then gotoxy(80,3)
                else gotoxy(81,3);
             write(map_num);
             gotoxy(71,4);write('                ');
             gotoxy(71+(16-length(map[map_num].name)) div 2,4);write(map[map_num].name);
             gotoxy(71,5);write('                ');
             textbackground(7);
             textcolor(0);
             for i:= 6 to 11 do
                 begin
                      gotoxy(71,i);write('                ');
                 end;
             gotoxy(71,7);write('     Scores     ');
             gotoxy(71,8);write('    00000000    ');
             gotoxy(71,9);write('  Best  Record  ');
             gotoxy(71,10);write('    00000000    ');
             case map[map_num].mrecord of
             0..9:gotoxy(82,10);
             10..99:gotoxy(81,10);
             100..999:gotoxy(80,10);
             1000..9999:gotoxy(79,10);
             10000..99999:gotoxy(78,10);
             100000..999999:gotoxy(77,10);
             1000000..9999999:gotoxy(76,10);
             else gotoxy(75,10);
             end;
             write(map[map_num].mrecord);        
             textbackground(8);
             textcolor(7);
             gotoxy(71,12);write('                ');
             gotoxy(71,13);write(' Pass Edge:     ');
             gotoxy(71,14);write(' Pass Wall:     ');
             gotoxy(82,13);
             if pe then write('on ')
                else write('off');
             gotoxy(82,14);
             if pw then write('on ')
                else write('off');               
             textbackground(7);
             textcolor(0);
             for i:= 16 to 28 do
                 begin
                      gotoxy(71,i);write('                ');
                 end;
             gotoxy(72,17);write('Speed(+-):',speed);
             repeat
                   key:=readkey;
                   if (key=#43) and (speed<991) then speed:=speed+10;
                   if (key=#45) and (speed>109) then speed:=speed-10;
                   gotoxy(82,17);write(speed);
                   if speed<1000 then
                      begin
                           gotoxy(85,17);write(' ');
                      end;
             until (key=#13) or (key=#27);
        end;
     if key=#13 then
        begin
             gotoxy(71,17);write('                ');
             gotoxy(72,17);write('Speed:',speed);
             gotoxy(21,3);write('      Press the leading arrow key to start      ');
             gotoxy(72,23);write('Multiple:',multiple);
             textbackground(8);
             textcolor(7);
             for i:= 19 to 21 do
                 begin
                      gotoxy(71,i);write('                ');
                 end;
             for i:= 25 to 28 do
                 begin
                      gotoxy(71,i);write('                ');
                 end;
             gotoxy(72,20);write('Length:',slength);
             gotoxy(72,26);write('[P]:Pause');
             gotoxy(72,27);write('[Esc]:Exit');
             repeat
                   key:=readkey;
             until ((key=#72) and (direction=1)) or ((key=#80) and (direction=2)) or ((key=#75) and (direction=3)) or ((key=#77) and (direction=4)) or (key=#27);
        end;
     if key=#27 then DrawSun;
     if key<>#27 then
        begin  
             textbackground(7);
             textcolor(0);
             gotoxy(21,3);write('                   Play  Mode                   ');
             Action;
        end;
     if key=#27 then DrawSun;
end;

begin
     writeln('Gluttonous Snake v2.0  by SUN CHOI');
     writeln('Make sure that the window size has adjusted to 88*29');
     writeln('Press Enter to continue');
     readln;
     clrscr;
     randomize;
     cursoroff;
     speed:=500;
     map_num:=0;
     for i:= 1 to 5 do
         begin
              itemx[i]:=-1;
              itemy[i]:=-1;
         end;
     for i:= 1 to 9999 do
         begin
              snakex[i]:=-1;
              snakey[i]:=-1;
         end;
     DrawSun;
     DrawFrame;
     gotoxy(1,1);    
     textbackground(7);
     textcolor(0);
     gotoxy(21,3);write('                   Main  Menu                   ');
     textbackground(8);
     textcolor(7);
     gotoxy(21,2);write('       Gluttonous Snake v2.0  by SUN CHOI       ');
     ReadData;
     repeat
           ClearScreen;
           choicestring[1]:='      Play      ';
           choicestring[2]:='   Map Editor   ';
           choicestring[3]:=' About the game ';
           textbackground(7);
           textcolor(0);
           gotoxy(21,3);write('                   Main  Menu                   ');
           gotoxy(21,8);write(' [Arrow keys/Enter]:Selection  [F5]:Reload data ');
           gotoxy(37,12);write(choicestring[1]);
           textbackground(8);
           textcolor(7);
           gotoxy(37,16);write(choicestring[2]);
           gotoxy(37,20);write(choicestring[3]);
           choice:=1;
           score:=0;
           gotoxy(1,1);
           repeat
                 key:=readkey;
                 if (choice>1) and (key=#72) then
                    begin
                         gotoxy(37,8+choice*4);
                         textbackground(8);
                         textcolor(7);               
                         write(choicestring[choice]);
                         choice:=choice-1;           
                         gotoxy(37,8+choice*4);
                         textbackground(7);
                         textcolor(0);
                         write(choicestring[choice]);
                    end;
                 if (choice<3) and (key=#80) then
                    begin
                         gotoxy(37,8+choice*4);
                         textbackground(8);
                         textcolor(7);               
                         write(choicestring[choice]);
                         choice:=choice+1;
                         gotoxy(37,8+choice*4);
                         textbackground(7);
                         textcolor(0);
                         write(choicestring[choice]);
                    end;
           until (key=#13) or (key=#63);
           if key=#13 then
              case choice of
              1:PlayMode;
              2:EditMap;
              3:AboutGame;
              end
              else ReadData;
     until False;
end.
