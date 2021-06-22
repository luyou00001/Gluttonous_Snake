program Gluttonous_Snake;

uses sysutils,crt,Math;

const NameString=' 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/*-+,.\_|`~!@#$%^&()[]{};'':"<>?';

type maparray = array [1..60,1..60] of longint;

type maprecord = record
     x,y,startx,starty,sdirection,mrecord,t:longint;
     s:string;
     name:string[14];
     xy,area:maparray;
     passedge,passwall:Boolean;
end;

var i,j,k,l,choice,map_num,slength,score,speed,direction,enlarge,multiple,total,tx,ty,item_num,camx,camy:longint;
    itemx,itemy:array [1..5] of longint;
    timepass:array [1..4] of longint;
    choicestring:array [1..5] of string;   
    temp:maprecord;
    map:array [0..24] of maprecord;
    die,pe,pw,acceleration,ssnake,sarea,continue,newmap,playing,GMMode:Boolean;
    snakex,snakey:array [1..9999] of longint;
    x,y,a:array [1..4] of word;
    infile,outfile:text;
    key:char; 

procedure ClearScreen;
var i:longint;
begin
     textbackground(8);
     for i:= 5 to 34 do
         begin
              gotoxy(21,i);
              write('                                                            ');
         end;
end;

procedure ClearLeft;
var i:longint;
begin
     textbackground(7);
     for i:= 5 to 31 do
         begin
              gotoxy(3,i);write('                ');
         end;
end;

procedure AboutGame;
begin
     textbackground(7);
     textcolor(0);
     gotoxy(21,3);write('                       About the game                       ');
     ClearScreen;
     textbackground(8);
     textcolor(7);
     gotoxy(21,6);write('  Gluttonous Snake v2.2 by Sen Sen                          ');
     gotoxy(21,8);write('  Collaborator: Kobe Li                                     ');
     gotoxy(21,10);write('  My website:                                               ');
     gotoxy(21,12);write('  https://www.facebook.com/luyou001                         ');
     gotoxy(21,14);write('  My email: luyou00001@gmail.com                            ');
     gotoxy(21,16);write('  Welcome for suggestions!                                  ');
     gotoxy(21,22);write('                           ********                         ');
     gotoxy(21,23);write('                           * ****                           ');
     gotoxy(21,24);write('                           ********                         ');
     gotoxy(21,25);write('                           * * * *                          ');
     gotoxy(21,26);write('                          *  ** *                           ');
     gotoxy(21,27);write('                         *   *    *                         ');
     gotoxy(21,33);write('                        Press  Enter                        ');
     repeat
           key:=readkey;
     until key=#13;
end;

procedure DrawSun;
var i:longint;
begin              
     textbackground(8);
     textcolor(7);
     for i:= 2 to 34 do
         begin                        
              gotoxy(3,i);write('                ');
              gotoxy(83,i);write('                ');
         end;
     textbackground(7);
     textcolor(0);
     for i:= 1 to 3 do
         begin
              gotoxy(3,4+i);write('                ');
              gotoxy(83,4+i);write('                ');
              gotoxy(3,28+i);write('                ');
              gotoxy(83,28+i);write('                ');
         end;
     for i:= 1 to 7 do
         begin
              gotoxy(3,14+i);write('                ');
              gotoxy(83,14+i);write('                ');
         end;
     for i:= 0 to 1 do
         begin
              textbackground(7);
              textcolor(0);
              gotoxy(6+80*i,9);write('         :');
              gotoxy(6+80*i,10);write('  ');
              gotoxy(6+80*i,11);write('          ');
              gotoxy(14+80*i,12);write('  ');
              gotoxy(6+80*i,13);write('          ');
              textbackground(8);
              textcolor(7);
              gotoxy(6+80*i,16);write('  ');
              gotoxy(6+80*i,17);write('  ');
              gotoxy(6+80*i,18);write('  ');
              gotoxy(6+80*i,19);write('  ');
              gotoxy(6+80*i,20);write('          ');
              gotoxy(14+80*i,16);write('''''');
              gotoxy(14+80*i,17);write('  ');
              gotoxy(14+80*i,18);write('  ');
              gotoxy(14+80*i,19);write('  ');
              textbackground(7);
              textcolor(0);
              gotoxy(6+80*i,23);write('    ');
              gotoxy(14+80*i,23);write('  ');
              gotoxy(6+80*i,24);write('      ');
              gotoxy(14+80*i,24);write('  ');
              gotoxy(6+80*i,25);write('  ');
              gotoxy(10+80*i,25);write('  ');
              gotoxy(14+80*i,25);write('  ');
              gotoxy(6+80*i,26);write('  ');
              gotoxy(10+80*i,26);write('      ');
              gotoxy(6+80*i,27);write('..');
              gotoxy(12+80*i,27);write('    ');
         end;
     gotoxy(3,6);write('    SUN CHOI    ');
     gotoxy(83,6);write('    SUN CHOI    ');
     gotoxy(3,30);write('    SUN CHOI    ');
     gotoxy(83,30);write('    SUN CHOI    ');
     textbackground(8);
     textcolor(7);
     gotoxy(3,3);write('    SUN CHOI    ');
     gotoxy(83,3);write('    SUN CHOI    ');
     gotoxy(3,33);write('    SUN CHOI    ');
     gotoxy(83,33);write('    SUN CHOI    ');
end;

procedure DrawFrame;
var i:longint;
begin
     textbackground(8);
     textcolor(7);
     gotoxy(21,3);write('             Gluttonous Snake v2.2  by SUN CHOI             ');
     gotoxy(1,1);
     textbackground(11);
     for i:= 1 to 100 do write(' ');
     gotoxy(1,35);
     for i:= 1 to 100 do write(' ');
     gotoxy(21,4);
     for i:= 1 to 60 do write(' ');
     for i:= 2 to 34 do
         begin
              gotoxy(1,i);write('  ');
              gotoxy(19,i);write('  ');
              gotoxy(81,i);write('  ');
              gotoxy(99,i);write('  ');
         end;
end;   

procedure ShowSnake;
var i:longint;
    sx,sy:array [1..9999] of longint;
begin
     for i:= 1 to slength do
         begin
              sx[i]:=snakex[i]-camx+15;
              sy[i]:=snakey[i]-camy+15;
         end;
     for i:= 2 to slength do
         if (sx[i]>=1) and (sx[i]<=30) and (sy[i]>=1) and (sy[i]<=30) then
            begin
                 if acceleration then textbackground(4)
                    else if map[map_num].xy[snakex[i],snakey[i]]=1 then textbackground(8)
                         else textbackground(7);
                 gotoxy(sx[i]*2+19,sy[i]+4);write('  ');
            end;
     if (sx[1]>=1) and (sx[1]<=30) and (sy[1]>=1) and (sy[1]<=30) then
        begin
             if acceleration then textbackground(4)
                else if map[map_num].xy[snakex[1],snakey[1]]=1 then textbackground(8)
                     else textbackground(7);
             if map[map_num].xy[snakex[1],snakey[1]]=1 then textcolor(7)
                else textcolor(0);
             gotoxy(sx[1]*2+19,sy[1]+4);
             case direction of
             1:write('''''');
             2:write('..');
             3:write(': ');
             4:write(' :');
             end;
        end;
end; 

procedure ShowArea;     
var i,j:longint;
begin
     for i:= 1 to 30 do
         for j:= 1 to 30 do
             begin
                  if map[map_num].xy[i+camx-15,j+camy-15]=1 then textcolor(0)
                     else textcolor(7);
                  if map[map_num].xy[i+camx-15,j+camy-15]=1 then textbackground(7)
                     else textbackground(8);       
                  gotoxy(i*2+19,j+4);
                  if map[map_num].area[i+camx-15,j+camy-15]<10 then write(0,map[map_num].area[i+camx-15,j+camy-15])
                     else write(map[map_num].area[i+camx-15,j+camy-15]);
             end;
end; 

function ItemPosition(x,y:longint):Boolean;
var i:longint;
begin
     ItemPosition:=False;
     for i:= 1 to 5 do
         if (itemx[i]=x) and (itemy[i]=y) then ItemPosition:=True;
end;

function SnakePosition(x,y:longint):Boolean;
var i:longint;
begin
     SnakePosition:=False;
     for i:= 1 to slength do
         if (snakex[i]=x) and (snakey[i]=y) then SnakePosition:=True;
end;

procedure ShowMap(x1,y1,x2,y2:longint);
var i,j:longint;
begin
     for i:= 1 to 30 do
         for j:= 1 to 30 do
             if (playing=False) or (map[map_num].xy[i+x1-15,j+y1-15]<>map[map_num].xy[i+x2-15,j+y2-15]) or ((SnakePosition(i+x1-15,j+y1-15)=False) and (ItemPosition(i+x1-15,j+y1-15)=False)) then
                begin
                     gotoxy(i*2+19,j+4);
                     if map[map_num].xy[i+x1-15,j+y1-15]=1 then textbackground(7)
                        else textbackground(8);
                     write('  ');
                end;
end;      

procedure ClearSnake;
var i:longint;
    sx,sy:array [1..9999] of longint;
begin
     for i:= 1 to slength do
         begin
              sx[i]:=snakex[i]-camx+15;
              sy[i]:=snakey[i]-camy+15;
         end;
     for i:= slength downto 1 do
         if (sx[i]>=1) and (sx[i]<=30) and (sy[i]>=1) and (sy[i]<=30) then
            begin
                 gotoxy(sx[i]*2+19,sy[i]+4);
                 if map[map_num].xy[snakex[i],snakey[i]]=1 then textbackground(7)
                    else textbackground(8);
                 write('  ');
            end;
end;

procedure ShowRight;
begin  
     textbackground(8);
     textcolor(7);
     for i:= 2 to 34 do
         begin
              gotoxy(83,i);write('                ');
         end;
     textbackground(7);
     textcolor(0);
     for i:= 5 to 18 do
         begin
              gotoxy(83,i);write('                ');
         end;
     for i:= 23 to 31 do
         begin
              gotoxy(83,i);write('                ');
         end;
     textbackground(7);
     textcolor(0);
     gotoxy(83,6);write(' Map 00         ');
     for i:= 0 to total do
         begin
              gotoxy(84+(i mod 5)*3,9+(i div 5)*2);
              if i<10 then write('0',i)
              else write(i);
         end;
     gotoxy(83,24);write(' Pass Edge:     ');
     gotoxy(83,25);write(' Pass Wall:     ');
     textbackground(8);
     textcolor(7);
     gotoxy(83,3);write('    Map Info    ');
     gotoxy(83,20);write('  Best  Record  ');
     gotoxy(83,33);write('    Map Info    ');
end;  

procedure PreviewMap;
var cx,cy:longint;
    key:char;
    translate:Boolean;
begin
     cx:=camx;
     cy:=camy;
     textbackground(7);
     textcolor(0);
     ClearLeft;
     gotoxy(3,6);write(' Preview Map    ');
     gotoxy(3,8);write(' [Arrow Keys]:  ');
     gotoxy(3,9);write(' Translation    ');
     gotoxy(3,10);write(' (larger than   ');
     gotoxy(3,11);write(' 30*30 only)    ');
     gotoxy(3,13);write(' [S]:           ');
     gotoxy(3,14);write(' Show Snake:on  ');
     gotoxy(3,16);write(' [A]:           ');
     gotoxy(3,17);write(' Show Area:off  ');
     gotoxy(3,19);write(' [Esc]:Exit     ');
     ssnake:=True;
     sarea:=False;
     repeat
           translate:=False;
           textbackground(7);
           textcolor(0);
           key:=readkey;
           case key of
           #72:
               if camy>15 then
                  begin
                       cy:=camy-1;
                       translate:=True;
                  end;
           #80:
               if camy<map[map_num].y-15 then
                  begin
                       cy:=camy+1;
                       translate:=True;
                  end;
           #75:
               if camx>15 then
                  begin
                       cx:=camx-1;
                       translate:=True;
                  end;
           #77:
               if camx<map[map_num].x-15 then
                  begin
                       cx:=camx+1;
                       translate:=True;
                  end;
           #115:
                begin
                     if ssnake then ssnake:=False
                        else ssnake:=True;
                     gotoxy(15,14);
                     if ssnake then
                        begin
                             write('on '); 
                             ShowSnake;
                        end
                        else
                            begin
                                 write('off');
                                 ClearSnake;
                                 if sarea then ShowArea;
                            end;
                end;
           #97:
                begin
                     if sarea then sarea:=False
                        else sarea:=True;
                     gotoxy(14,17);
                     if sarea then
                        begin
                             write('on ');
                             ShowArea;
                        end
                        else
                            begin         
                                 write('off');
                                 ShowMap(camx,camy,camx,camy);
                            end;     
                     if ssnake then ShowSnake;
                end;
           end;
           if translate then
              begin
                   ShowMap(cx,cy,camx,camy);
                   camx:=cx;
                   camy:=cy;
                   if sarea then ShowArea;
                   if ssnake then ShowSnake;
              end;
     until key=#27;
end;

procedure MapInfo;
begin                     
     textbackground(8);
     textcolor(7);
     gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
     if map_num<10 then write('0',map_num)
        else write(map_num);
     textbackground(7);
     textcolor(0);
     gotoxy(88,6);write('0');
     if map_num<10 then gotoxy(89,6)
        else gotoxy(88,6);
     write(map_num,' (',map[map_num].x,'*',map[map_num].y,')');
     gotoxy(83,7);write('                ');
     gotoxy(83+(16-length(map[map_num].name)) div 2,7);write(map[map_num].name);
     textbackground(8);
     textcolor(7);
     gotoxy(83,21);write('    00000000    ');
     case map[map_num].mrecord of
     0..9:gotoxy(94,21);
     10..99:gotoxy(93,21);
     100..999:gotoxy(92,21);
     1000..9999:gotoxy(91,21);
     10000..99999:gotoxy(90,21);
     100000..999999:gotoxy(89,21);
     1000000..9999999:gotoxy(88,21);
     else gotoxy(87,21);
     end;
     pe:=map[map_num].passedge;
     pw:=map[map_num].passwall;
     write(map[map_num].mrecord);
     textbackground(7);
     textcolor(0);
     gotoxy(94,24);
     if pe then write('on ')
        else write('off');
     gotoxy(94,25);
     if pw then write('on ')
        else write('off');
end;

procedure SaveSnake;
begin         
     with map[map_num] do
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

procedure ShowInfo;
begin
     MapInfo;
     direction:=map[map_num].sdirection;
     SaveSnake;
     if (map[map_num].x=30) or (snakex[1]<=15) then camx:=15
        else if camx>map[map_num].x-15 then camx:=map[map_num].x-15
             else camx:=snakex[1];
     if (map[map_num].y=30) or (snakey[1]<=15) then camy:=15
        else if camy>map[map_num].y-15 then camy:=map[map_num].y-15
             else camy:=snakey[1];
     ShowMap(camx,camy,camx,camy);
     ShowSnake;
end;

procedure ShowScore;
begin
     textbackground(8);
     textcolor(7);
     gotoxy(83,11);write('    00000000    ');
     case score of
     0..9:gotoxy(94,11);
     10..99:gotoxy(93,11);
     100..999:gotoxy(92,11);
     1000..9999:gotoxy(91,11);
     10000..99999:gotoxy(90,11);
     100000..999999:gotoxy(89,11);
     1000000..9999999:gotoxy(88,11);
     else gotoxy(87,11);
     end;
     write(score);
     if score>map[map_num].mrecord then
        begin
             gotoxy(83,13);write('    00000000    ');
             case score of
             0..9:gotoxy(94,13);
             10..99:gotoxy(93,13);
             100..999:gotoxy(92,13);
             1000..9999:gotoxy(91,13);
             10000..99999:gotoxy(90,13);
             100000..999999:gotoxy(89,13);
             1000000..9999999:gotoxy(88,13);
             else gotoxy(87,13);
             end;
             write(score);
        end;
end;

procedure ShowItem(num:longint);
var ix,iy,mx,my:longint;
    pattern:array [1..2] of char;
begin         
     ix:=itemx[num]-camx+15;
     iy:=itemy[num]-camy+15;
     if (ix>=1) and (ix<=30) and (iy>=1) and (iy<=30) then
        begin
             gotoxy(ix*2+19,iy+4);
             case num of
             1:textbackground(2);
             2:textbackground(6);
             3:textbackground(4);
             4:textbackground(1);
             5:textbackground(5);
             end;
             if map[map_num].area[itemx[num],itemy[num]]<>map[map_num].area[snakex[1],snakey[1]] then
                begin
                     if map[map_num].xy[snakex[num],snakey[num]]=1 then textcolor(7)
                        else textcolor(0);
                     write('><');
                end
                else write('  ');
        end
        else
            begin
                 pattern[1]:=' ';
                 pattern[2]:=' ';
                 if ix<1 then
                    begin
                         mx:=1;
                         pattern[1]:=chr(17);
                    end
                    else if ix>30 then
                         begin
                              mx:=30;
                              pattern[2]:=chr(16);
                         end
                         else mx:=ix;
                 if iy<1 then
                    begin
                         my:=1;
                         if pattern[1]=' ' then pattern[1]:=chr(30)
                            else pattern[2]:=chr(30);
                    end
                    else if iy>30 then
                         begin
                              my:=30;  
                              if pattern[1]=' ' then pattern[1]:=chr(31)
                                 else pattern[2]:=chr(31);
                         end
                         else my:=iy;
                 if pattern[1]=' ' then pattern[1]:=pattern[2];
                 if pattern[2]=' ' then pattern[2]:=pattern[1];
                 gotoxy(mx*2+19,my+4);
                 if map[map_num].xy[mx+camx-15,my+camy-15]=1 then
                    begin
                         textbackground(7);
                         textcolor(0);
                    end
                    else
                        begin
                             textbackground(8);
                             textcolor(7);
                        end;
                 for i:= 1 to 5 do
                     if (itemx[i]=mx+camx-15) and (itemy[i]=my+camy-15) then
                        case i of
                        1:textbackground(2);
                        2:textbackground(6);
                        3:textbackground(4);
                        4:textbackground(1);
                        5:textbackground(5);
                        end;
                 write(pattern[1],pattern[2]);
            end;
end;

procedure GenItem(num:longint);
var i,tx,ty:longint;
    onsnake,onitem:Boolean;
begin
     repeat
           tx:=random(map[map_num].x)+1;
           ty:=random(map[map_num].y)+1;
           onsnake:=False;
           onitem:=False;
           i:=0;
           while (i<slength) and (onsnake=False) do
                 begin
                      i:=i+1;
                      if (snakex[i]=tx) and (snakey[i]=ty) then onsnake:=True;
                 end;
           i:=0;
           while (i<5) and (onitem=False) do
                 begin
                      i:=i+1;
                      if (itemx[i]=tx) and (itemy[i]=ty) then onitem:=True;
                 end;
     until (onsnake=False) and (onitem=False) and (pw or ((pw=False) and (map[map_num].area[tx,ty]=1)));
     itemx[num]:=tx;
     itemy[num]:=ty;
     ShowItem(num);
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
     gotoxy(21,13);write('                         Loading...                         ');
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
                          for i:= 1 to 60 do
                              for j:= 1 to 60 do xy[i,j]:=-1;
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
         for j:= 1 to 60 do
             for k:= 1 to 60 do map[i].area[j,k]:=-1;
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

procedure Save(map:maprecord);
begin 
     with map do
          begin
               writeln(outfile,name);
               writeln(outfile,x);
               writeln(outfile,y);
               writeln(outfile,mrecord);
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
          end;
end;

procedure SaveData(num:longint);
begin           
     textbackground(8);
     textcolor(7);
     ClearScreen;
     gotoxy(21,13);write('                         Loading...                         ');
     assign(outfile,'map.txt');
     rewrite(outfile);
     for i:= 0 to total do
         begin
              if i=num then Save(temp)
                 else Save(map[i]);
              if i<total then writeln(outfile);
         end;
     close(outfile);
     ReadData;
end;

procedure GameOver;
var sx,sy:longint;
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
              sx:=snakex[i]-camx+15;
              sy:=snakey[i]-camy+15;
              if (sx>=1) and (sx<=30) and (sy>=1) and (sy<=30) then
                 begin
                      gotoxy(sx*2+19,sy+4);
                      if map[map_num].xy[snakex[i],snakey[i]]=1 then textbackground(7)
                         else textbackground(8);
                      write('  ');
                 end;
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
              gotoxy(21,i);write('                                                            ');
         end;
     for i:= 23 to 25 do
         begin
              gotoxy(21,i);write('                                                            ');
         end;
     gotoxy(28,6);write('          ');
     gotoxy(40,6);write('          ');
     gotoxy(52,6);write('    ');
     gotoxy(58,6);write('    ');
     gotoxy(64,6);write('          ');
     gotoxy(28,7);write('  ');
     gotoxy(40,7);write('  ');
     gotoxy(48,7);write('  ');
     gotoxy(52,7);write('          ');
     gotoxy(64,7);write('  ');
     gotoxy(28,8);write('  ');
     gotoxy(32,8);write('      ');
     gotoxy(40,8);write('          ');
     gotoxy(52,8);write('  ');
     gotoxy(56,8);write('  ');
     gotoxy(60,8);write('  ');
     gotoxy(64,8);write('          ');
     gotoxy(28,9);write('  ');
     gotoxy(36,9);write('  ');
     gotoxy(40,9);write('  ');
     gotoxy(48,9);write('  ');
     gotoxy(52,9);write('  ');
     gotoxy(60,9);write('  ');
     gotoxy(64,9);write('  ');
     gotoxy(28,10);write('          ');
     gotoxy(40,10);write('  ');
     gotoxy(48,10);write('  ');
     gotoxy(52,10);write('  ');
     gotoxy(60,10);write('  ');
     gotoxy(64,10);write('          ');
     textbackground(8);
     gotoxy(28,13);write('          ');
     gotoxy(40,13);write('  ');
     gotoxy(48,13);write('  ');
     gotoxy(52,13);write('          ');
     gotoxy(64,13);write('          ');
     gotoxy(28,14);write('  ');
     gotoxy(36,14);write('  ');
     gotoxy(40,14);write('  ');
     gotoxy(48,14);write('  ');
     gotoxy(52,14);write('  ');
     gotoxy(64,14);write('  ');
     gotoxy(72,14);write('  ');
     gotoxy(28,15);write('  ');
     gotoxy(36,15);write('  ');
     gotoxy(40,15);write('    ');
     gotoxy(46,15);write('    ');
     gotoxy(52,15);write('          ');
     gotoxy(64,15);write('          ');
     gotoxy(28,16);write('  ');
     gotoxy(36,16);write('  ');
     gotoxy(42,16);write('      ');
     gotoxy(52,16);write('  ');
     gotoxy(64,16);write('  ');
     gotoxy(68,16);write('  ');
     gotoxy(28,17);write('          ');
     gotoxy(44,17);write('  ');
     gotoxy(52,17);write('          ');
     gotoxy(64,17);write('  ');
     gotoxy(68,17);write('      ');
     textcolor(7);
     gotoxy(23,20);write('Map 0'); 
     if map_num>=10 then gotoxy(27,20)
        else gotoxy(28,20);
     write(map_num,' (',map[map_num].x,'*',map[map_num].y,')');
     gotoxy(23,21);write(map[map_num].name);
     gotoxy(39,20);write('Score      :',score);
     if GMMode then
        begin
             textcolor(13);
             write(' GM Mode');
             score:=0;
             textcolor(7);
        end;
     if score>map[map_num].mrecord then write(' New record!');
     gotoxy(39,21);write('Best Record:');
     if score>map[map_num].mrecord then write(score)
        else write(map[map_num].mrecord);
     gotoxy(21,33);write('                        Press  Enter                        ');
     textbackground(7);
     textcolor(0);
     gotoxy(23,24);write('Speed:');
     if acceleration then write(speed div 2)
        else write(speed);
     gotoxy(35,24);write('Final Length:',slength);
     gotoxy(53,24);write('Multiple:');
     if acceleration then write(multiple div 2)
        else write(multiple);
     while keypressed do key:=readkey;
     repeat
           key:=readkey;
     until key=#13;
     temp:=map[map_num];
     if score>temp.mrecord then temp.mrecord:=score;
     SaveData(map_num);
end;

procedure SnakeMove(tx,ty:longint);
var sx,sy,cx,cy:longint;
    t1,t2,t3,temp:Boolean;
begin
     t1:=False;
     t2:=False;
     t3:=False;
     temp:=False;
     if (itemx[1]=tx) and (itemy[1]=ty) then
        begin
             enlarge:=enlarge+1;
             score:=score+((multiple+5)*(1000+speed) div 10);
             if acceleration then multiple:=multiple+2
                else multiple:=multiple+1;
             t1:=True;
             ShowScore;
             textbackground(8);
             if acceleration then textcolor(12)
                else textcolor(7);
             gotoxy(93,26);write(multiple,' ');
        end;
     if (itemx[2]=tx) and (itemy[2]=ty) then
        begin
             score:=score+((multiple+5)*(1000+speed) div 2);
             if acceleration then multiple:=multiple+6
                else multiple:=multiple+3;
             t2:=True;
             ShowScore;
             textbackground(8);
             if acceleration then textcolor(12)
                else textcolor(7);
             gotoxy(93,26);write(multiple,' ');
        end;
     if (itemx[3]=tx) and (itemy[3]=ty) then
        begin
             acceleration:=True;
             speed:=speed*2;
             multiple:=multiple*2;
             pw:=False;
             textbackground(7);
             textcolor(12);
             gotoxy(94,17);write('off');
             textbackground(8);
             gotoxy(90,20);write(speed,' ');
             gotoxy(93,26);write(multiple,' ');
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
             if (enlarge=0) and ((map[map_num].x>30) or (map[map_num].y>30)) then
                begin
                     if (map[map_num].x=30) or (tx<15) then cx:=15
                        else if tx>map[map_num].x-15 then cx:=map[map_num].x-15
                             else cx:=tx;
                     if (map[map_num].y=30) or (ty<15) then cy:=15
                        else if ty>map[map_num].y-15 then cy:=map[map_num].y-15
                             else cy:=ty;
                     if (cx<>camx) or (cy<>camy) then
                        begin
                             for i:= slength downto 2 do
                                 begin
                                      snakex[i]:=snakex[i-1];
                                      snakey[i]:=snakey[i-1];
                                 end;
                             snakex[1]:=tx;
                             snakey[1]:=ty;
                             ShowMap(cx,cy,camx,camy); 
                             camx:=cx;
                             camy:=cy;
                             ShowItem(1);
                             for i:= 2 to 5 do
                                 if itemx[i]<>-1 then ShowItem(i);
                        end
                        else temp:=True;
                end
                else if enlarge=0 then temp:=True;
                if temp then
                   begin
                        sx:=snakex[slength]-camx+15;
                        sy:=snakey[slength]-camy+15;
                        if (sx>=1) and (sx<=30) and (sy>=1) and (sy<=30) then
                           begin
                                gotoxy(sx*2+19,sy+4);
                                if map[map_num].xy[snakex[slength],snakey[slength]]=1 then textbackground(7)
                                   else textbackground(8);
                                write('  ');
                           end;
                        for i:= slength downto 2 do
                            begin
                                 snakex[i]:=snakex[i-1];
                                 snakey[i]:=snakey[i-1];
                            end;
                        snakex[1]:=tx;
                        snakey[1]:=ty; 
                        ShowItem(1);
                        for i:= 2 to 5 do
                            if itemx[i]<>-1 then ShowItem(i);
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
                     if (map[map_num].x>30) or (map[map_num].y>30) then
                        begin
                             cx:=tx;
                             cy:=ty;
                             if cx<15 then cx:=15;
                             if cx>map[map_num].x-15 then cx:=map[map_num].x-15;
                             if cy<15 then cy:=15;
                             if cy>map[map_num].y-15 then cy:=map[map_num].y-15;
                             if (cx<>camx) or (cy<>camy) then
                                begin
                                     ShowMap(cx,cy,camx,camy);
                                     camx:=cx;
                                     camy:=cy;
                                     ShowItem(1);
                                     for i:= 2 to 5 do
                                         if itemx[i]<>-1 then ShowItem(i);
                                end;
                        end;
                     textbackground(7);
                     textcolor(0);
                     gotoxy(91,23);write(slength,' ');
                end;
             if enlarge<0 then
                begin
                     tx:=snakex[slength];
                     ty:=snakey[slength];
                     sx:=tx-camx+15;
                     sy:=ty-camy+15;
                     snakex[slength]:=-1;
                     snakey[slength]:=-1;
                     if (sx>=1) and (sx<=30) and (sy>=1) and (sy<=30) then
                        begin
                             gotoxy(sx*2+19,sy+4);
                             if map[map_num].xy[tx,ty]=1 then textbackground(7)
                                else textbackground(8);
                             write('  ');
                        end;
                     slength:=slength-1;
                     enlarge:=enlarge+1;
                     textbackground(7);
                     textcolor(0);
                     gotoxy(91,23);write(slength,' ');
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
var i,tx,ty:longint;
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
     if (map[map_num].xy[tx,ty]<>map[map_num].xy[snakex[1],snakey[1]]) and (enlarge>=0) then die:=True;
     for i:= 1 to slength do
         if (snakex[i]=tx) and (snakey[i]=ty) and (enlarge>=0) then die:=True;
     if die=False then SnakeMove(tx,ty);
end;

procedure PassWall;
var t,tx,ty,cx,cy:longint;
    pass:Boolean;
begin
     pass:=False;
     direction:=direction-4;
     tx:=snakex[1];
     ty:=snakey[1];
     case direction of
     1..2:
          begin
               t:=snakex[1]-1;
               if t=0 then t:=map[map_num].x;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[t,ty] then
                  begin
                       direction:=3;
                       tx:=t;
                       pass:=True;
                  end;
               t:=snakex[1]+1;
               if t=map[map_num].x+1 then t:=1;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[t,ty] then
                  begin      
                       direction:=4;
                       tx:=t;
                       pass:=True;
                  end;
          end;
     3..4:
          begin
               t:=snakey[1]-1;
               if t=0 then t:=map[map_num].y;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[tx,t] then
                  begin           
                       direction:=1;
                       ty:=t;
                       pass:=True;
                  end;
               t:=snakey[1]+1;
               if t=map[map_num].x+1 then t:=1;
               if map[map_num].xy[snakex[1],snakey[1]]<>map[map_num].xy[tx,t] then
                  begin         
                       direction:=2;
                       ty:=t;
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
                     if (map[map_num].x>30) or (map[map_num].y>30) then
                        begin
                             cx:=snakex[1];
                             cy:=snakey[1];
                             if cx<15 then cx:=15;
                             if cx>map[map_num].x-15 then cx:=map[map_num].x-15;
                             if cy<15 then cy:=15;
                             if cy>map[map_num].y-15 then cy:=map[map_num].y-15;
                             if (cx<>camx) or (cy<>camy) then
                                begin
                                     ShowMap(cx,cy,camx,camy);
                                     camx:=cx;
                                     camy:=cy;
                                     ShowSnake;
                                end;
                        end;
                     ShowItem(1);
                     for i:= 2 to 5 do
                         if itemx[i]<>-1 then ShowItem(i);
                 end;
        end
        else ChangeDirection;
end;

function NoItem:Boolean;
begin
     NoItem:=True;
     for i:= 2 to 5 do
         if itemx[i]<>-1 then NoItem:=False;
end;

procedure Action;
var ix,iy:longint;
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
           if GMMode then
              repeat
                    key:=readkey;
              until key<>' ';
           if keypressed then key:=readkey;
           if ((timepass[1]+timepass[3]>=50000 div speed) and (GMMode=False)) or (GMMode and ((key=#72) or (key=#80) or (key=#75) or (key=#77) or (key=#120)))  then
              begin
                   if (enlarge>=0) and (key<>' ') then
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
                   DecodeTime(time,x[1],x[2],x[3],x[4]);
              end; 
           if NoItem and (acceleration=False) and (enlarge=0) then
              begin
                   if GMMode then item_num:=random(4)+2
                      else item_num:=random(2500000)+2;
                   if ((item_num<6) and (slength>5)) or ((item_num<5) and (slength+enlarge<=5)) then
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
                   gotoxy(21,3);write('          Pause... Press the arrow key to continue          ');
                   repeat
                         key:=readkey;
                   until ((key=#72) and (direction<>2)) or ((key=#80) and (direction<>1)) or ((key=#75) and (direction<>4)) or ((key=#77) and (direction<>3)) or (key=#27);
                   gotoxy(21,3);write('                          Play  Mode                        ');
                   DecodeTime(time,x[1],x[2],x[3],x[4]); 
                   DecodeTime(time,a[1],a[2],a[3],a[4]);
              end;
           if (timepass[2]+timepass[4]>=100*map[map_num].x*map[map_num].y div 9) and (NoItem=False) and (GMMode=False) then
              begin                 
                   for i:= 2 to 5 do
                       if itemx[i]<>-1 then
                           begin
                                ix:=itemx[i]-camx+15;
                                iy:=itemy[i]-camy+15;
                                if (ix>=1) and (ix<=30) and (iy>=1) and (iy<=30) then
                                   begin
                                        gotoxy(ix*2+19,iy+4);
                                        if map[map_num].xy[itemx[i],itemy[i]]=1 then textbackground(7)
                                           else textbackground(8);
                                        write('  ');
                                   end;
                           end;
                   for i:= 2 to 5 do
                       begin
                            itemx[i]:=-1;
                            itemy[i]:=-1;
                       end;
              end;
           if (timepass[2]+timepass[4]>=5000*power(map[map_num].x*map[map_num].y div 900,0.5)) and acceleration then
              begin                 
                   acceleration:=False;
                   speed:=speed div 2;
                   multiple:=multiple div 2;
                   pw:=map[map_num].passwall;          
                   textbackground(7);
                   textcolor(0);
                   gotoxy(94,17);
                   if map[map_num].passwall then write('on ')
                      else write('off');
                   textbackground(8);
                   textcolor(7);
                   gotoxy(90,20);write(speed,' ');
                   gotoxy(93,26);write(multiple,' ');
              end;
     until die or (key=#27);
     if die then GameOver;
     if acceleration then speed:=speed div 2;
end;

procedure ShowIteminfo;
begin 
     textbackground(8);
     for i:= 2 to 34 do
         begin
              gotoxy(3,i);write('                ');
         end;       
     textbackground(7);  
     for i:= 5 to 10 do
         begin
              gotoxy(3,i);write('                ');
         end;  
     for i:= 16 to 20 do
         begin
              gotoxy(3,i);write('                ');
         end;
     for i:= 24 to 26 do
         begin
              gotoxy(3,i);write('                ');
         end;
     for i:= 32 to 34 do
         begin
              gotoxy(3,i);write('                ');
         end;
     textbackground(2);
     gotoxy(4,6);write('  ');
     textbackground(6);
     gotoxy(4,12);write('  ');
     textbackground(4);
     gotoxy(4,17);write('  ');
     textbackground(1);
     gotoxy(4,22);write('  ');
     textbackground(5);
     gotoxy(4,25);write('  ');
     textbackground(7);
     textcolor(0);
     gotoxy(7,6);write('Food');
     gotoxy(4,7);write('+Few Scores');
     gotoxy(4,8);write('Length+1');
     gotoxy(4,9);write('Multiple+1');
     gotoxy(7,17);write('Multiple*2');
     gotoxy(4,18);write('Pass Wall:off');
     gotoxy(4,19);write('Speed*2 (5s)');
     gotoxy(7,25);write('length-5');
     gotoxy(3,33);write('   Item  Info   ');
     textbackground(8);
     textcolor(7);
     gotoxy(3,3);write ('   Item  Info   ');
     gotoxy(7,12);write('Treasure');
     gotoxy(4,13);write('+many scores');
     gotoxy(4,14);write('multiple+3');
     gotoxy(7,22);write('length+5');
     gotoxy(4,28);write('[Arrow Keys]:');
     gotoxy(4,29);write('Move/Continue');
     gotoxy(4,30);write('[X]:Pass Wall');
end;

procedure PlayMode;
begin    
     for i:= 1 to 5 do
         begin
              itemx[i]:=-1;
              itemy[i]:=-1;
         end;
     textbackground(7);
     textcolor(0);
     gotoxy(21,3);write('                         Play  Mode                         ');
     textbackground(8);
     textcolor(7);
     for i:= 2 to 34 do
         begin
              gotoxy(3,i);write('                ');
              gotoxy(83,i);write('                ');
         end;
     gotoxy(3,3);write('   Key  Table   ');
     gotoxy(3,33);write('   Key  Table   ');
     textbackground(7);
     textcolor(0);
     ClearLeft;
     gotoxy(3,6);write(' [Arrow Keys]:  ');
     gotoxy(3,7);write(' Choose map     ');
     gotoxy(3,9);write(' [Enter]:       ');
     gotoxy(3,10);write(' Continue       ');
     gotoxy(3,12);write(' [Esc]:Exit     ');
     textbackground(7);
     textcolor(0); 
     for i:= 5 to 18 do
         begin
              gotoxy(83,i);write('                ');
         end;  
     for i:= 23 to 31 do
         begin
              gotoxy(83,i);write('                ');
         end;  
     textbackground(7);
     textcolor(0);
     gotoxy(83,6);write(' Map 00         ');
     for i:= 0 to total do
         begin
              gotoxy(84+(i mod 5)*3,9+(i div 5)*2);
              if i<10 then write('0',i)
                 else write(i);
         end;
     gotoxy(83,24);write(' Pass Edge:     ');
     gotoxy(83,25);write(' Pass Wall:     ');
     textbackground(8);
     textcolor(7);        
     gotoxy(83,3);write('    Map Info    ');
     gotoxy(83,20);write('  Best  Record  ');
     gotoxy(83,33);write('    Map Info    ');
     slength:=6;
     enlarge:=0;
     acceleration:=False;
     multiple:=1;
     die:=False;
     ShowInfo;
     repeat
           key:=readkey;
           if (key=#77) and (map_num<total) then
              begin 
                   textbackground(7);
                   textcolor(0);
                   gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                   if map_num<10 then write('0',map_num)
                      else write(map_num);
                   map_num:=map_num+1;
                   ShowInfo;
              end;
           if (key=#75) and (map_num>0) then
              begin           
                   textbackground(7);
                   textcolor(0);
                   gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                   if map_num<10 then write('0',map_num)
                      else write(map_num);
                   map_num:=map_num-1;
                   ShowInfo;
              end;      
           if (key=#72) and (map_num>4) then
              begin     
                   textbackground(7);
                   textcolor(0);
                   gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                   if map_num<10 then write('0',map_num)
                      else write(map_num);
                   map_num:=map_num-5;
                   ShowInfo;
              end;
           if (key=#80) and (map_num<(total div 5)*5) and (map_num+5<=total) then
              begin   
                   textbackground(7);
                   textcolor(0);
                   gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                   if map_num<10 then write('0',map_num)
                      else write(map_num);
                   map_num:=map_num+5;
                   ShowInfo;
              end;
     until (key=#13) or (key=#27);
     if key=#13 then
        begin
             textbackground(7);
             textcolor(0);
             ClearLeft;
             gotoxy(3,6);write(' [Left]:        ');
             gotoxy(3,7);write(' Speed-10       ');
             gotoxy(3,9);write(' [Right]:       ');
             gotoxy(3,10);write(' Speed+10       ');
             gotoxy(3,12);write(' [Up]:          ');
             gotoxy(3,13);write(' Speed:1000     ');
             gotoxy(3,15);write(' [Down]:        ');
             gotoxy(3,16);write(' Speed:100      ');
             gotoxy(3,18);write(' [Enter]:       ');
             gotoxy(3,19);write(' Continue       ');
             gotoxy(3,21);write(' [Esc]:Exit     ');
             textbackground(8);
             textcolor(7);
             for i:= 9 to 14 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;
             gotoxy(83,10);write('     Scores     '); 
             ShowScore;
             gotoxy(83,12);write('  Best  Record  ');
             gotoxy(83,13);write('    00000000    ');
             case map[map_num].mrecord of
             0..9:gotoxy(94,13);
             10..99:gotoxy(93,13);
             100..999:gotoxy(92,13);
             1000..9999:gotoxy(91,13);
             10000..99999:gotoxy(90,13);
             100000..999999:gotoxy(89,13);
             1000000..9999999:gotoxy(88,13);
             else gotoxy(87,13);
             end;
             write(map[map_num].mrecord);
             textbackground(7);
             textcolor(0);    
             for i:= 15 to 18 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;
             gotoxy(83,16);write(' Pass Edge:     ');
             gotoxy(83,17);write(' Pass Wall:     ');
             gotoxy(94,16);
             if pe then write('on ')
                else write('off');
             gotoxy(94,17);
             if pw then write('on ')
                else write('off');
             textbackground(8);
             textcolor(7);
             for i:= 19 to 31 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;       
             textbackground(7);
             textcolor(0);
             for i:= 32 to 34 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;
             gotoxy(83,33);write('    Map Info    '); 
             textbackground(8);
             textcolor(7);
             gotoxy(84,20);write('Speed:',speed);
             repeat
                   key:=readkey;
                   if key=#72 then speed:=1000;
                   if key=#80 then speed:=100;
                   if (key=#77) and (speed<=990) then speed:=speed+10;
                   if (key=#75) and (speed>=110) then speed:=speed-10;
                   gotoxy(90,20);write(speed,' ');
             until (key=#13) or (key=#27);
        end;
     if key=#13 then
        begin         
             textbackground(7);
             textcolor(0);
             ClearLeft;
             gotoxy(3,6);write(' Press the      ');
             gotoxy(3,7);write(' leading arrow  ');
             gotoxy(3,8);write(' key to start   ');
             gotoxy(3,10);write(' [Esc]:Exit     ');
             for i:= 22 to 24 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;
             for i:= 28 to 31 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;
             gotoxy(84,23);write('Length:',slength);
             gotoxy(84,29);write('[P]:Pause');
             gotoxy(84,30);write('[Esc]:Exit');
             textbackground(8);
             textcolor(7);
             for i:= 25 to 27 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;  
             gotoxy(84,26);write('Multiple:',multiple);
             for i:= 32 to 34 do
                 begin
                      gotoxy(83,i);write('                ');
                 end;
             gotoxy(83,33);write('    Map Info    '); 
             repeat
                   key:=readkey;
             until ((key=#72) and (direction=1)) or ((key=#80) and (direction=2)) or ((key=#75) and (direction=3)) or ((key=#77) and (direction=4)) or (key=#27);
        end;
     if key<>#27 then
        begin
             ShowIteminfo; 
             playing:=True;
             Action;       
             playing:=False;
        end;
end;

procedure ClearCursor(cx,cy:longint);
begin
     if map[map_num].xy[cx,cy]=1 then textbackground(7)
        else textbackground(8);
     gotoxy(cx*2+19,cy+4);write('  ');
end;

procedure ShowCursor(cx,cy,cc:longint);
begin
     textbackground(2); 
     textcolor(cc);
     gotoxy(cx*2+19,cy+4);write('><'); 
     textbackground(8);
     textcolor(7);
     gotoxy(83,11);write(' Cursor:        ');
     gotoxy(91,11);write('(',cx,',',cy,')');
end;

procedure SaveModified;
var ckey:char;
begin
     ClearScreen;
     choicestring[1]:='  Yes  ';
     choicestring[2]:='  No  ';
     textbackground(8);
     textcolor(7);
     gotoxy(21,6);write(' If you make changes, the record will be cleared. Continue? ');
     gotoxy(41,12);write(choicestring[1]);
     textbackground(7);
     textcolor(0);
     gotoxy(36,8);write(' [Arrow keys/Enter]:Selection ');
     gotoxy(53,12);write(choicestring[2]);
     choice:=2;
     repeat
           ckey:=readkey;
           if (ckey=#75) and (choice=2) then
              begin
                   choice:=1;
                   textbackground(7);
                   textcolor(0);
                   gotoxy(41,12);write(choicestring[1]);
                   textbackground(8);
                   textcolor(7);
                   gotoxy(53,12);write(choicestring[2]);
              end;
           if (ckey=#77) and (choice=1) then
              begin
                   choice:=2;
                   textbackground(8);
                   textcolor(7);
                   gotoxy(41,12);write(choicestring[1]);
                   textbackground(7);
                   textcolor(0);
                   gotoxy(53,12);write(choicestring[2]);
              end;
     until ckey=#13;
end;   

function Movable(tarea:longint):Boolean;
var i,j,count,temp:longint;
    valid:Boolean;
begin
     Movable:=True;
     with map[map_num] do
          for i:= 1 to x do
              for j:= 1 to y do
                  if area[i,j]=tarea then
                  begin
                       valid:=False;
                       count:=0;
                       temp:=1;
                       if (i-1>0) and (area[i-1,j]=tarea) then
                          begin
                               count:=count+1;
                               temp:=temp*2;
                          end;
                       if (i+1<x+1) and (area[i+1,j]=tarea) then
                          begin
                               count:=count+1;
                               temp:=temp*2;
                          end;
                       if (j-1>0) and (area[i,j-1]=tarea) then
                          begin
                               count:=count+1;
                               temp:=temp*3;
                          end;
                       if (j+1<y+1) and (area[i,j+1]=tarea) then
                          begin
                               count:=count+1;
                               temp:=temp*3;
                          end;
                       if (count>=3) or ((count=2) and (temp=6)) then valid:=True;
                       if valid=False then Movable:=False;
                  end;
end;    

procedure Rename;
var nlength,position:longint;
    exist,insert,pressed:Boolean;
    temp:array[1..2] of string[14];
    key:char;
begin 
     textbackground(7);
     textcolor(0);
     ClearLeft;
     gotoxy(3,6);write(' Rename Map     '); 
     gotoxy(3,8);write(' [Left/Right]:  ');
     gotoxy(3,9);write(' Control cursor ');
     gotoxy(3,11);write(' [Backspace/    ');
     gotoxy(3,12);write('  Delete]:      ');
     gotoxy(3,13);write(' Delete 1 char. ');
     gotoxy(3,15);write(' [Insert]:      ');
     gotoxy(3,16);write(' Insert on/off  ');
     gotoxy(3,18);write(' [Enter]:Finish ');
     gotoxy(3,20);write(' [Esc]:Exit     ');
     gotoxy(83,7);write('                ');
     gotoxy(84,7);write(map[map_num].name);
     temp[1]:=map[map_num].name;
     exist:=True;
     insert:=False;
     nlength:=length(map[map_num].name);
     position:=length(map[map_num].name)+1;
     DecodeTime(time,x[1],x[2],x[3],x[4]);
     repeat
           pressed:=False;
           key:=' ';
           DecodeTime(time,y[1],y[2],y[3],y[4]);
           timepass[1]:=(y[1]-x[1])*3600000+(y[2]-x[2])*60000+(y[3]-x[3])*1000+(y[4]-x[4]);
           if keypressed then
              begin
                   pressed:=True;
                   key:=readkey; 
                   exist:=True;
              end;
           if key=#0 then
              begin
                   key:=readkey;
                   if (key=#75) and (position>1) then
                      begin
                           position:=position-1;
                           exist:=False;
                      end;
                   if (key=#77) and (position<nlength+1) and ((insert=False) or (position<14)) then
                      begin
                           position:=position+1;
                           exist:=False;
                      end;
                   if (key=#82) and insert then insert:=False
                      else if key=#82 then
                           begin
                                insert:=True;
                                if position>14 then position:=14;
                           end;
                   if (key=#83) and (nlength>0) and (position<=nlength) then
                      begin
                           temp[2]:='';
                           for i:= 1 to nlength do if i<>position then temp[2]:=temp[2]+temp[1][i];
                           temp[1]:=temp[2];
                           nlength:=nlength-1;
                      end;
              end
              else if pressed and (pos(key,NameString)>0) and (insert or ((nlength<14) and (insert=False))) then
                 begin
                      temp[2]:='';
                      for i:= 1 to position-1 do temp[2]:=temp[2]+temp[1][i];
                      temp[2]:=temp[2]+key;
                      if insert and (position<=nlength) then for i:= position+1 to nlength do temp[2]:=temp[2]+temp[1][i]
                         else
                             begin
                                  for i:= position to nlength do temp[2]:=temp[2]+temp[1][i];
                                  nlength:=nlength+1;
                                  if (insert=False) or (position<14) then position:=position+1;
                             end;
                      temp[1]:=temp[2];
                 end;
           if (key=#8) and (position>1) then
              begin
                   temp[2]:='';
                   for i:= 1 to nlength do if i<>position-1 then temp[2]:=temp[2]+temp[1][i];
                   temp[1]:=temp[2];
                   nlength:=nlength-1;
                   position:=position-1;
              end;
           if pressed then
              begin
                   timepass[1]:=200;
                   gotoxy(83,7);write('                ');
                   gotoxy(84,7);write(temp[1]);
              end;
           if timepass[1]>=200 then
              begin
                   textbackground(7);
                   textcolor(0);
                   gotoxy(83+position,7);
                   if exist and (position>nlength) then write(' ')
                      else if exist then write(temp[1][position])
                           else if insert then write('_')
                                else write('|');
                   if exist then exist:=False
                      else exist:=True;
                   DecodeTime(time,x[1],x[2],x[3],x[4]);
              end;
     until (key=#13) or (key=#27);
     if key=#13 then
        begin
             map[map_num].name:=temp[1];
             if continue then map[map_num].mrecord:=0;
             SaveData(total+1);
             ShowMap(camx,camy,camx,camy);
             ShowSnake;
        end;
     MapInfo;
end;

procedure DeleteMap;
begin      
     total:=total-1;
     for i:= map_num to total do map[i]:=map[i+1];
     SaveData(total+1);
     if map_num=total+1 then map_num:=map_num-1;
end;

procedure ResetSP;
var i,editted:longint;
    temp:maprecord;
    key,skey:char;
    valid,finish:Boolean;
begin 
     textbackground(7);
     textcolor(0);
     ClearLeft;
     gotoxy(3,6);write(' Reset Start Pt ');
     gotoxy(3,8);write(' [Arrow Keys]:  ');
     gotoxy(3,9);write(' Set Start Pt   ');
     gotoxy(3,11);write(' [W]:Upwards    ');
     gotoxy(3,13);write(' [S]:Downwards  ');
     gotoxy(3,15);write(' [A]:Left       ');
     gotoxy(3,17);write(' [D]:Right      ');
     gotoxy(3,19);write(' [Enter]:Finish ');
     gotoxy(3,21);write(' [Esc]:Exit     ');
     textbackground(8);
     textcolor(7);
     for i:= 9 to 16 do
         begin
              gotoxy(83,i);write('                ');
         end;
     gotoxy(83,10);write(' Coordinates of ');
     gotoxy(83,11);write(' start point:   ');
     gotoxy(84,12);write('(',map[map_num].startx,',',map[map_num].starty,')');
     gotoxy(83,14);write(' Direction:     ');
     gotoxy(84,15);
     case direction of
     1:write('Upwards  ');
     2:write('Downwards');
     3:write('Left     ');
     4:write('Right    ');
     end;
     textbackground(7);
     textcolor(0);
     for i:= 17 to 31 do
         begin
              gotoxy(83,i);write('                ');
         end; 
     temp:=map[map_num];
     finish:=False;
     repeat
           editted:=0;
           key:=readkey;
           with map[map_num] do
                case key of
                #72: if ((direction=2) and (starty>6)) or ((direction<>2) and (starty>1)) then
                        begin
                             editted:=1;
                             starty:=starty-1;
                        end;
                #80: if ((direction=1) and (starty<y-5)) or ((direction<>1) and (starty<y)) then
                        begin
                             editted:=1;
                             starty:=starty+1;
                        end;
                #75: if ((direction=4) and (startx>6)) or ((direction<>4) and (startx>1)) then
                        begin
                             editted:=1;
                             startx:=startx-1;
                        end;
                #77: if ((direction=3) and (startx<x-5)) or ((direction<>3) and (startx<x)) then
                        begin
                             editted:=1;
                             startx:=startx+1;
                        end;
                #119:if (direction<>1) and (starty<=y-5) then
                        begin
                             editted:=2;
                             direction:=1;
                        end;
                #115:if (direction<>2) and (starty>=6) then
                        begin
                             editted:=2;
                             direction:=2;
                        end;
                #97 :if (direction<>3) and (startx<=x-5) then
                        begin
                             editted:=2;
                             direction:=3;
                        end;
                #100:if (direction<>4) and (startx>=6) then
                        begin
                             editted:=2;
                             direction:=4;
                        end;
                #13:
                     begin
                          valid:=True;
                          for i:= 2 to slength do
                              if area[snakex[1],snakey[1]]<>area[snakex[i],snakey[i]] then valid:=False;
                          case direction of
                          1:if (snakey[1]-1=0) or (area[snakex[1],snakey[1]]<>area[snakex[1],snakey[1]-1]) then valid:=False;
                          2:if (snakey[1]+1=31) or (area[snakex[1],snakey[1]]<>area[snakex[1],snakey[1]+1]) then valid:=False;
                          3:if (snakex[1]-1=0) or (area[snakex[1],snakey[1]]<>area[snakex[1]-1,snakey[1]]) then valid:=False;
                          4:if (snakey[1]+1=31) or (area[snakex[1],snakey[1]]<>area[snakex[1]+1,snakey[1]]) then valid:=False;
                          end;
                          if Movable(area[snakex[1],snakey[1]]) and valid then
                             begin
                                  if continue then map[map_num].mrecord:=0;
                                  map[map_num].sdirection:=direction;
                                  SaveData(total+1);
                                  finish:=True;
                                  ShowMap(camx,camy,camx,camy);
                             end
                             else
                                 begin
                                      textbackground(8);
                                      textcolor(7);
                                      ClearScreen;
                                      gotoxy(21,6);write('  The starting point is invalid! Please reset!              ');
                                      gotoxy(21,33);write('                        Press  Enter                        ');
                                      repeat
                                            skey:=readkey;
                                      until skey=#13;
                                      ShowMap(camx,camy,camx,camy);
                                      ShowSnake;
                                 end;
                     end;
                end;
           if editted>0 then
              begin
                   ClearSnake;
                   SaveSnake;
                   ShowSnake;  
                   textbackground(8);
                   textcolor(7);
                   if editted=1 then
                      begin   
                           gotoxy(84,12);write('(',map[map_num].startx,',',map[map_num].starty,')  ');
                      end;
                   if editted=2 then
                      begin    
                           gotoxy(84,15);
                           case direction of
                           1:write('Upwards  ');
                           2:write('Downwards');
                           3:write('Left     ');
                           4:write('Right    ');
                           end;
                      end;
              end;
     until finish or (key=#27);
     if key=#27 then
        if newmap then
           begin
                DeleteMap;
                continue:=False;
           end
           else map[map_num]:=temp;
     ClearSnake;
     SaveSnake;
     ShowSnake;
     ShowRight;
     MapInfo;
end;   

procedure EditMap;
var cc,cx,cy,sx,sy,ex,ey,unum,i,j,totalarea:longint;
    skey:char;
    e,save,modified,available,acceptable:Boolean;
    temp:array [0..11] of maprecord;
begin
     textbackground(7);
     textcolor(0);
     ClearLeft;
     gotoxy(3,6);write(' Edit map       ');
     gotoxy(3,8);write(' [Arrow Keys]:  ');
     gotoxy(3,9);write(' Control cursor ');
     gotoxy(3,11);write(' [W]:           ');
     gotoxy(3,12);write(' Colour:white   ');
     gotoxy(3,14);write(' [B]:           ');
     gotoxy(3,15);write(' Colour:black   ');
     gotoxy(3,17);write(' [D]:           ');
     gotoxy(3,18);write(' Draw dot       ');
     gotoxy(3,20);write(' [R]:           ');
     gotoxy(3,21);write(' Draw range     ');
     gotoxy(3,23);write(' [X]:Undo(0)    ');
     gotoxy(3,25);write(' [S]:Save map   ');
     gotoxy(3,27);write(' [Esc]:Exit     ');
     textbackground(8);
     textcolor(7);
     for i:= 9 to 14 do
         begin
              gotoxy(83,i);write('                ');
         end;
     gotoxy(83,10);write(' Coordinates of ');
     gotoxy(83,11);write(' Cursor:        ');
     gotoxy(83,13);write(' Colour:white   ');
     textbackground(7);
     textcolor(0);
     for i:= 15 to 31 do
         begin
              gotoxy(83,i);write('                ');
         end; 
     cx:=1;
     cy:=1;
     cc:=7;
     temp[0]:=map[map_num];
     temp[1]:=map[map_num];
     unum:=0;
     ClearSnake;
     ShowCursor(cx,cy,cc);
     repeat
           e:=False;
           save:=False;
           key:=readkey;
           case key of
           #72,#80,#75,#77:
                begin
                     ClearCursor(cx,cy);
                     if (key=#72) and (cy>1) then cy:=cy-1;
                     if (key=#80) and (cy<map[map_num].y) then cy:=cy+1;
                     if (key=#75) and (cx>1) then cx:=cx-1;
                     if (key=#77) and (cx<map[map_num].x) then cx:=cx+1;
                     ShowCursor(cx,cy,cc);
                end;
           #119:
                begin
                     cc:=7;  
                     textbackground(8);
                     textcolor(7);
                     gotoxy(91,13);write('white');
                     ShowCursor(cx,cy,cc);
                end;
           #98: 
                begin
                     cc:=0;   
                     textbackground(8);
                     textcolor(7);
                     gotoxy(91,13);write('black');
                     ShowCursor(cx,cy,cc);
                end;
           #100:    
                begin
                     if cc=7 then
                        begin
                             textbackground(7);
                             map[map_num].xy[cx,cy]:=1;
                        end
                        else
                            begin    
                                 textbackground(8);
                                 map[map_num].xy[cx,cy]:=0;
                            end;
                     gotoxy(cx*2+19,cy+4);write('  ');
                     if unum<10 then
                        begin
                             unum:=unum+1;
                             temp[unum+1]:=map[map_num];
                             textbackground(7);
                             textcolor(0);
                             gotoxy(12,23);write('(',unum,') ');
                        end
                        else
                            begin
                                 for i:= 1 to 10 do temp[i]:=temp[i+1];
                                 temp[11]:=map[map_num];
                            end;
                end;
           #114: 
                begin   
                     textbackground(7);
                     textcolor(0);
                     ClearLeft;
                     gotoxy(3,6);write(' Draw range     ');
                     gotoxy(3,8);write(' [Arrow Keys]:  ');
                     gotoxy(3,9);write(' Control range  ');
                     gotoxy(3,11);write(' [R]:Finish     ');
                     gotoxy(3,13);write(' [C]:Cancel     ');
                     sx:=cx;
                     sy:=cy;
                     ex:=cx;
                     ey:=cy;
                     if cc=7 then
                        begin
                             textbackground(7); 
                             textcolor(0);
                        end
                        else
                            begin
                                 textbackground(8);
                                 textcolor(7);
                            end;
                     gotoxy(ex*2+19,ey+4);write('><');
                     repeat
                           key:=readkey;
                           case key of
                           #72,#80,#75,#77:
                                begin
                                     if cc=7 then textbackground(7)
                                        else textbackground(8);
                                     gotoxy(ex*2+19,ey+4);write('  ');
                                end;
                           end;
                           case key of
                           #72:
                                if ey>1 then
                                   begin
                                        if ey>sy then
                                           begin
                                                if ex>sx then
                                                   for i:= sx to ex do
                                                       begin
                                                            if map[map_num].xy[i,ey]=1 then textbackground(7)
                                                               else textbackground(8);
                                                            gotoxy(i*2+19,ey+4);write('  ');
                                                       end
                                                   else
                                                       for i:= ex to sx do
                                                           begin
                                                                if map[map_num].xy[i,ey]=1 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(i*2+19,ey+4);write('  ');
                                                           end;
                                                ey:=ey-1;
                                           end
                                           else
                                               begin
                                                    ey:=ey-1;
                                                    if ex>sx then
                                                       for i:= sx to ex do
                                                           begin
                                                                if cc=7 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(i*2+19,ey+4);write('  ');
                                                           end
                                                       else
                                                           for i:= ex to sx do
                                                               begin
                                                                    if cc=7 then textbackground(7)
                                                                       else textbackground(8);
                                                                    gotoxy(i*2+19,ey+4);write('  ');
                                                               end;
                                               end;
                                   end;
                           #80:
                                if ey<map[map_num].y then
                                   begin
                                        if ey<sy then
                                           begin
                                                if ex>sx then
                                                   for i:= sx to ex do
                                                       begin
                                                            if map[map_num].xy[i,ey]=1 then textbackground(7)
                                                               else textbackground(8);
                                                            gotoxy(i*2+19,ey+4);write('  ');
                                                       end
                                                   else
                                                       for i:= ex to sx do
                                                           begin
                                                                if map[map_num].xy[i,ey]=1 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(i*2+19,ey+4);write('  ');
                                                           end;
                                                ey:=ey+1;
                                           end
                                           else
                                               begin
                                                    ey:=ey+1;
                                                    if ex>sx then
                                                       for i:= sx to ex do
                                                           begin
                                                                if cc=7 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(i*2+19,ey+4);write('  ');
                                                           end
                                                       else
                                                           for i:= ex to sx do
                                                               begin
                                                                    if cc=7 then textbackground(7)
                                                                       else textbackground(8);
                                                                    gotoxy(i*2+19,ey+4);write('  ');
                                                               end;
                                               end;
                                   end;
                           #75:
                                if ex>1 then
                                   begin
                                        if ex>sx then
                                           begin
                                                if ey>sy then
                                                   for i:= sy to ey do
                                                       begin
                                                            if map[map_num].xy[ex,i]=1 then textbackground(7)
                                                               else textbackground(8);
                                                            gotoxy(ex*2+19,i+4);write('  ');
                                                       end
                                                   else
                                                       for i:= ey to sy do
                                                           begin
                                                                if map[map_num].xy[ex,i]=1 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(ex*2+19,i+4);write('  ');
                                                           end;
                                                ex:=ex-1;
                                           end
                                           else
                                               begin
                                                    ex:=ex-1;
                                                    if ey>sy then
                                                       for i:= sy to ey do
                                                           begin
                                                                if cc=7 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(ex*2+19,i+4);write('  ');
                                                           end
                                                       else
                                                           for i:= ey to sy do
                                                               begin
                                                                    if cc=7 then textbackground(7)
                                                                       else textbackground(8);
                                                                    gotoxy(ex*2+19,i+4);write('  ');
                                                               end;
                                               end;
                                   end;
                           #77:
                                if ex<map[map_num].x then
                                   begin
                                        if ex<sx then
                                           begin
                                                if ey>sy then
                                                   for i:= sy to ey do
                                                       begin
                                                            if map[map_num].xy[ex,i]=1 then textbackground(7)
                                                               else textbackground(8);
                                                            gotoxy(ex*2+19,i+4);write('  ');
                                                       end
                                                   else
                                                       for i:= ey to sy do
                                                           begin
                                                                if map[map_num].xy[ex,i]=1 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(ex*2+19,i+4);write('  ');
                                                           end;
                                                ex:=ex+1;
                                           end
                                           else
                                               begin
                                                    ex:=ex+1;
                                                    if ey>sy then
                                                       for i:= sy to ey do
                                                           begin
                                                                if cc=7 then textbackground(7)
                                                                   else textbackground(8);
                                                                gotoxy(ex*2+19,i+4);write('  ');
                                                           end
                                                       else
                                                           for i:= ey to sy do
                                                               begin
                                                                    if cc=7 then textbackground(7)
                                                                       else textbackground(8);
                                                                    gotoxy(ex*2+19,i+4);write('  ');
                                                               end;
                                               end;
                                   end;
                           #114:
                                begin
                                     cx:=ex;
                                     cy:=ey;
                                     if cc=7 then textbackground(7)
                                        else textbackground(8);
                                     gotoxy(sx*2+19,sy+4);write('  ');
                                     gotoxy(ex*2+19,ey+4);write('  ');
                                     if sx>ex then
                                        begin
                                             sx:=sx+ex;
                                             ex:=sx-ex;
                                             sx:=sx-ex;
                                        end;
                                     if sy>ey then
                                        begin
                                             sy:=sy+ey;
                                             ey:=sy-ey;
                                             sy:=sy-ey;
                                        end;
                                     for i:= sx to ex do
                                         for j:= sy to ey do
                                             if cc=7 then map[map_num].xy[i,j]:=1
                                                else map[map_num].xy[i,j]:=0;
                                     if unum<10 then
                                        begin
                                             unum:=unum+1;
                                             temp[unum+1]:=map[map_num];
                                             textbackground(7);
                                             textcolor(0);
                                        end
                                        else
                                            begin
                                                 for i:= 1 to 10 do temp[i]:=temp[i+1];
                                                 temp[11]:=map[map_num];
                                            end;
                                end;
                           #99:
                                begin
                                     cx:=ex;
                                     cy:=ey;
                                     ShowMap(camx,camy,camx,camy);
                                     ShowCursor(cx,cy,cc);
                                end;
                           end;
                           case key of
                           #72,#80,#75,#77:
                                begin
                                     if cc=7 then
                                        begin
                                             textbackground(7);
                                             textcolor(0);
                                        end
                                        else
                                            begin
                                                 textbackground(8);
                                                 textcolor(7);
                                            end;
                                     gotoxy(sx*2+19,sy+4);write('><');
                                     gotoxy(ex*2+19,ey+4);write('><');
                                     textbackground(8);
                                     textcolor(7);
                                     gotoxy(83,11);write(' Cursor:        ');
                                     gotoxy(91,11);write('(',ex,',',ey,')');
                                end;
                           end;
                     until (key=#114) or (key=#99); 
                     textbackground(7);
                     textcolor(0);
                     ClearLeft;
                     gotoxy(3,6);write(' Edit map       ');
                     gotoxy(3,8);write(' [Arrow Keys]:  ');
                     gotoxy(3,9);write(' Control cursor ');
                     gotoxy(3,11);write(' [W]:           ');
                     gotoxy(3,12);write(' Colour:white   ');
                     gotoxy(3,14);write(' [B]:           ');
                     gotoxy(3,15);write(' Colour:black   ');
                     gotoxy(3,17);write(' [D]:           ');
                     gotoxy(3,18);write(' Draw dot       ');
                     gotoxy(3,20);write(' [R]:           ');
                     gotoxy(3,21);write(' Draw range     ');
                     gotoxy(3,23);write(' [X]:Undo(0)    ');
                     gotoxy(3,25);write(' [S]:Save map   ');
                     gotoxy(3,27);write(' [Esc]:Exit     ');
                     gotoxy(12,23);write('(',unum,') ');
                end;
           #120:
                if unum>0 then
                   begin
                        map[map_num]:=temp[unum];
                        unum:=unum-1;
                        textbackground(7);
                        textcolor(0);
                        gotoxy(12,23);write('(',unum,') ');
                        ShowMap(camx,camy,camx,camy);
                        ShowCursor(cx,cy,cc);
                   end;
           #115:save:=True;
           #27:
                begin
                     modified:=False;
                     for i:= 1 to 60 do
                         for j:= 1 to 60 do
                             if map[map_num].xy[i,j]<>temp[0].xy[i,j] then modified:=True;
                     if modified then
                        begin
                             ClearScreen;
                             choicestring[1]:='  Yes  ';
                             choicestring[2]:=' Cancel ';
                             choicestring[3]:='  No  ';
                             textbackground(8);
                             textcolor(7);
                             gotoxy(21,6);write('                Do you want to save changes?                ');     
                             gotoxy(37,12);write(choicestring[1]);
                             gotoxy(57,12);write(choicestring[3]);
                             textbackground(7);
                             textcolor(0);
                             gotoxy(36,8);write(' [Arrow keys/Enter]:Selection ');
                             gotoxy(47,12);write(choicestring[2]);
                             choice:=2;
                             repeat
                                   key:=readkey;
                                   if (key=#75) and (choice>1) then
                                      begin           
                                           textbackground(8);
                                           textcolor(7);
                                           gotoxy(27+choice*10,12);write(choicestring[choice]);
                                           choice:=choice-1;                                   
                                           textbackground(7);
                                           textcolor(0);
                                           gotoxy(27+choice*10,12);write(choicestring[choice]);
                                      end;
                                   if (key=#77) and (choice<3) then
                                      begin           
                                           textbackground(8);
                                           textcolor(7);
                                           gotoxy(27+choice*10,12);write(choicestring[choice]);
                                           choice:=choice+1;
                                           textbackground(7);
                                           textcolor(0);
                                           gotoxy(27+choice*10,12);write(choicestring[choice]);
                                      end;
                             until key=#13;
                             case choice of
                             1:
                               begin
                                    ClearScreen;
                                    ShowMap(camx,camy,camx,camy);
                                    save:=True;
                               end;
                             2:
                               begin
                                    ClearScreen;
                                    ShowMap(camx,camy,camx,camy);
                                    ShowCursor(cx,cy,cc);
                               end;
                             3:
                               begin
                                    map[map_num]:=temp[0];
                                    e:=True;
                               end;
                             end;
                        end
                        else e:=True;
                end;
           end;
           if save then
              begin
                   modified:=False;
                   for i:= 1 to 60 do
                       for j:= 1 to 60 do
                           if map[map_num].xy[i,j]<>temp[0].xy[i,j] then modified:=True;
              end;
           if modified and (map[map_num].mrecord>0) and save then
              begin
                   SaveModified;
                   if choice=1 then map[map_num].mrecord:=0;
                   if choice=2 then
                      begin
                           ShowMap(camx,camy,camx,camy);
                           ShowCursor(cx,cy,cc);
                           save:=False;
                      end;
              end;
           if save then
              begin
                   available:=True;
                   acceptable:=False;
                   totalarea:=0;
                   for i:= 1 to map[map_num].x do
                       for j:= 1 to map[map_num].y do
                           if totalarea<map[map_num].area[i,j] then totalarea:=map[map_num].area[i,j];
                   i:=0;
                   while (i<totalarea) or ((acceptable=False) and available) do
                         begin
                              i:=i+1;
                              if Movable(i) then acceptable:=True;
                              if Movable(i)=False then available:=False;
                         end;
                   if acceptable=False then
                      begin
                           textbackground(8);
                           textcolor(7);
                           ClearScreen;
                           gotoxy(21,6);write('  There are no available areas! Please edit again!          ');
                           gotoxy(21,33);write('                        Press  Enter                        ');
                           repeat
                                 skey:=readkey;
                           until skey=#13;
                           ShowMap(camx,camy,camx,camy);
                           ShowCursor(cx,cy,cc);
                           save:=False;
                      end
                      else if available=False then map[map_num].passwall:=False;
                   SaveData(total+1);
                   if newmap then
                      begin
                           ShowMap(camx,camy,camx,camy);
                           ShowSnake;
                           continue:=True;
                           ResetSP;
                           if continue then Rename;
                      end;
              end;
     until save or e;
end;

procedure TurnOnOffPE;
begin
     textbackground(7);
     textcolor(0);
     gotoxy(94,24);
     if map[map_num].passedge then
        begin
             map[map_num].passedge:=False;
             write('off');
        end
        else
            begin
                 map[map_num].passedge:=True;
                 write('on ');
            end;
     if continue then
        begin
             map[map_num].mrecord:=0;
             textbackground(8);
             textcolor(7);
             gotoxy(83,21);write('    00000000    ');
        end;
     SaveData(total+1);
     ShowMap(camx,camy,camx,camy);
     ShowSnake;
end;

procedure TurnOnOffPW;
var i,j,totalarea:longint;
    skey:char;
    available:Boolean;
begin     
     textbackground(7);
     textcolor(0);
     gotoxy(94,25);
     available:=True;
     if map[map_num].passwall=False then
        begin
             totalarea:=0;
             for i:= 1 to map[map_num].x do
                 for j:= 1 to map[map_num].y do
                     if totalarea<map[map_num].area[i,j] then totalarea:=map[map_num].area[i,j];
             i:=0;
             while (i<totalarea) and (available=True) do
                   begin
                        i:=i+1;
                        if Movable(i)=False then available:=False;
                   end;
             if available then
                begin
                     map[map_num].passwall:=True;
                     write('on ');
                end
                else
                    begin 
                         textbackground(8);
                         textcolor(7);
                         ClearScreen;
                         gotoxy(21,6);write('  The map is not available for turning on pass wall!        ');
                         gotoxy(21,33);write('                        Press  Enter                        ');
                         repeat
                               skey:=readkey;
                         until skey=#13;
                         ShowMap(camx,camy,camx,camy);
                         ShowSnake;
                    end;
        end
        else
            begin 
                 map[map_num].passwall:=False;
                 write('off');
            end;
     if available then
        begin
             if continue then
                begin
                     map[map_num].mrecord:=0;
                     textbackground(8);
                     textcolor(7);
                     gotoxy(83,21);write('    00000000    ');
                end;
             SaveData(total+1);
             ShowMap(camx,camy,camx,camy);
             ShowSnake;
        end;
end;

procedure ResetMapInfo;
var key:char;
begin
     repeat
           textbackground(7);
           textcolor(0);
           ClearLeft;
           gotoxy(3,6);write(' Reset Map Info ');
           gotoxy(3,8);write(' [N]:           ');
           gotoxy(3,9);write(' Rename Map     ');
           gotoxy(3,11);write(' [P]:           ');
           gotoxy(3,12);write(' Start Point    ');
           gotoxy(3,14);write(' [E]:           ');
           gotoxy(3,15);write(' Turn on/off    ');
           gotoxy(3,16);write(' Pass Edge      ');
           gotoxy(3,18);write(' [W]:           ');
           gotoxy(3,19);write(' Turn on/off    ');
           gotoxy(3,20);write(' Pass Wall      ');
           gotoxy(3,22);write(' [Esc]:Exit     ');
           repeat
                 continue:=False;
                 key:=readkey;
                 if ((key=#110) or (key=#112) or (key=#101) or (key=#119)) and (map[map_num].mrecord>0) then
                    begin
                         SaveModified;
                         if choice=1 then continue:=True;
                         ShowMap(camx,camy,camx,camy);
                         ShowSnake;
                    end
                    else choice:=1;
                 if choice=1 then
                    case key of
                    #110:Rename;
                    #112:ResetSP;
                    #101:TurnOnOffPE;
                    #119:TurnOnOffPW;
                    end;
           until (key=#110) or (key=#112) or (key=#27);
     until key=#27;
end;

procedure MapEditor;
var temp:longint;
    ckey:char;
begin
     temp:=0;   
     textbackground(7);
     textcolor(0);
     gotoxy(21,3);write('                         Map Editor                         ');
     repeat         
           camx:=15;
           camy:=15;
           newmap:=False;
           if (temp=0) or (temp=1) then
              begin
                   textbackground(8);
                   textcolor(7);
                   for i:= 2 to 34 do
                       begin
                            gotoxy(3,i);write('                ');
                       end;
                   gotoxy(3,3);write('   Key  Table   ');
                   gotoxy(3,33);write('   Key  Table   ');
                   textbackground(7);
                   textcolor(0);
                   ClearLeft;
                   gotoxy(3,6);write(' [Arrow Keys]:  ');
                   gotoxy(3,7);write(' Choose map     ');
                   gotoxy(3,9);write(' [P]:           ');
                   gotoxy(3,10);write(' Preview map    ');
                   gotoxy(3,12);write(' [E]:           ');
                   gotoxy(3,13);write(' Edit map       ');
                   gotoxy(3,15);write(' [R]:           ');
                   gotoxy(3,16);write(' Reset Map Info ');
                   gotoxy(3,18);write(' [D]:           ');
                   gotoxy(3,19);write(' Delete map     ');
                   gotoxy(3,21);write(' [N]:           ');
                   gotoxy(3,22);write(' Create new map ');
                   gotoxy(3,24);write(' [C]:           ');
                   gotoxy(3,25);write(' Copy map       ');
                   gotoxy(3,27);write(' [Esc]:Exit     ');
              end;
           if (temp=0) or (temp=3) then
              begin  
                   ShowRight;
                   slength:=6;
                   enlarge:=0;
                   acceleration:=False;
                   multiple:=1;
                   die:=False;
                   ShowInfo;
              end;
           if temp=2 then
              begin
                   ShowMap(camx,camy,camx,camy);
                   ShowSnake;
              end;
           if temp>0 then temp:=0;
           repeat
                 key:=readkey;
                 if (key=#77) and (map_num<total) then
                    begin
                         textbackground(7);
                         textcolor(0);
                         gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                         if map_num<10 then write('0',map_num)
                            else write(map_num);
                         map_num:=map_num+1;
                         ShowInfo;
                    end;
                 if (key=#75) and (map_num>0) then
                    begin
                         textbackground(7);
                         textcolor(0);
                         gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                         if map_num<10 then write('0',map_num)
                            else write(map_num);
                         map_num:=map_num-1;
                         ShowInfo;
                    end;
                 if (key=#72) and (map_num>4) then
                    begin
                         textbackground(7);
                         textcolor(0);
                         gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                         if map_num<10 then write('0',map_num)
                            else write(map_num);
                         map_num:=map_num-5;
                         ShowInfo;
                    end;
                 if (key=#80) and (map_num<(total div 5)*5) and (map_num+5<=total) then
                    begin
                         textbackground(7);
                         textcolor(0);
                         gotoxy(84+(map_num mod 5)*3,9+(map_num div 5)*2);
                         if map_num<10 then write('0',map_num)
                            else write(map_num);
                         map_num:=map_num+5;
                         ShowInfo;
                    end;
                 if ((key=#101) or (key=#114) or (key=#100)) and (map_num=0) then
                    begin
                         ClearScreen;
                         textbackground(8);
                         textcolor(7);
                         gotoxy(21,6);write('  Map 00 cannot be editted or deleted!                      ');
                         gotoxy(21,33);write('                        Press  Enter                        ');
                         repeat
                               key:=readkey;
                         until key=#13;
                         ShowMap(camx,camy,camx,camy);
                         ShowSnake;
                    end;
                 if (key=#100) and (map_num>0) then
                    begin
                         ClearScreen;
                         choicestring[1]:='  Yes  ';
                         choicestring[2]:='  No  ';
                         textbackground(8);
                         textcolor(7);
                         gotoxy(21,6);write('          Are you sure you want to delete the map?          ');
                         gotoxy(41,12);write(choicestring[1]);
                         textbackground(7);
                         textcolor(0);
                         gotoxy(36,8);write(' [Arrow keys/Enter]:Selection ');
                         gotoxy(53,12);write(choicestring[2]);
                         choice:=2;
                         repeat
                               ckey:=readkey;
                               if (ckey=#75) and (choice=2) then
                                  begin
                                       choice:=1;
                                       textbackground(7);
                                       textcolor(0);
                                       gotoxy(41,12);write(choicestring[1]);
                                       textbackground(8);
                                       textcolor(7);
                                       gotoxy(53,12);write(choicestring[2]);
                                  end;
                               if (ckey=#77) and (choice=1) then
                                  begin
                                       choice:=2;
                                       textbackground(8);
                                       textcolor(7);
                                       gotoxy(41,12);write(choicestring[1]);
                                       textbackground(7);
                                       textcolor(0);
                                       gotoxy(53,12);write(choicestring[2]);
                                  end;
                         until ckey=#13;
                    end;
                 if ((key=#110) or (key=#99)) and (total=24) then
                    begin
                         ClearScreen;
                         textbackground(8);
                         textcolor(7);
                         gotoxy(21,6);write('  Database full! Please delete the redundant maps!          ');
                         gotoxy(21,33);write('                        Press  Enter                        ');
                         repeat
                               key:=readkey;
                         until key=#13;
                         ShowMap(camx,camy,camx,camy);
                         ShowSnake;
                    end;
           until (key=#112) or ((key=#101) and (map_num>0)) or ((key=#114) and (map_num>0)) or ((key=#100) and (map_num>0)) or (((key=#110) or (key=#99)) and (total<24)) or (key=#27);
           if key<>#27 then
              begin
                   if key=#114 then temp:=1;
                   if (key=#100) and (choice=2) then temp:=2;
                   case key of
                   #112:PreviewMap;
                   #101:EditMap;
                   #114:ResetMapInfo;
                   #100:if choice=1 then
                           begin
                                DeleteMap;
                                temp:=3;
                           end;
                   #110:
                       begin
                            total:=total+1;
                            map[total]:=map[0];
                            map[total].name:='New map';
                            map[total].mrecord:=0;
                            map_num:=total;
                            SaveData(total+1);
                            ShowInfo;
                            newmap:=True;
                            EditMap;
                       end;
                   #99:
                       begin
                            total:=total+1;
                            map[total]:=map[map_num];
                            if length(map[total].name)>9 then
                               begin
                                    map[total].name:='';
                                    for i:= 1 to 8 do map[total].name:=map[total].name+map[map_num].name[i];
                                    map[total].name:=map[total].name+'.';
                               end;
                            map[total].name:=map[total].name+'-Copy';
                            map[total].mrecord:=0;
                            map_num:=total;
                            SaveData(total+1);
                            ShowInfo;
                            newmap:=True;
                            EditMap;
                       end;
                   end; 
                   key:=' ';
              end;
     until key=#27;
end;

begin
     writeln('Gluttonous Snake v2.2  by SUN CHOI');
     writeln('Make sure that the window size has adjusted to 100*35');
     writeln('If not, please adjust the window size into 100*35 and restart the game');
     writeln('Press Enter to continue');
     readln;
     clrscr;
     randomize;
     cursoroff;
     speed:=500;
     map_num:=0;     
     GMMode:=False;
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
     gotoxy(21,3);write('                         Main  Menu                         ');
     textbackground(8);
     textcolor(7);
     gotoxy(21,2);write('             Gluttonous Snake v2.2  by SUN CHOI             ');
     ReadData; 
     choice:=1;
     playing:=False;
     repeat    
           camx:=15;
           camy:=15;
           ClearScreen;
           choicestring[1]:='      Play      ';
           choicestring[2]:='   Map Editor   ';
           choicestring[3]:=' About the game ';
           textbackground(7);
           textcolor(0);
           gotoxy(21,3);write('                         Main  Menu                         ');
           gotoxy(27,8);write(' [Arrow keys/Enter]:Selection  [F5]:Reload data ');
           for i:= 1 to 3 do
               begin
                    if choice=i then
                       begin 
                            textbackground(7);
                            textcolor(0);
                       end
                       else
                           begin
                                textbackground(8);
                                textcolor(7);
                           end;
                    gotoxy(43,8+i*4);write(choicestring[i]);
               end;
           score:=0;
           gotoxy(1,1);
           repeat
                 key:=readkey;
                 if key=#83 then
                    begin
                         key:=readkey;
                         if key=#85 then
                            begin
                                 key:=readkey;
                                 if key=#78 then
                                    begin
                                         if GMMode=False then
                                            begin   
                                                 textbackground(11);
                                                 textcolor(13);
                                                 gotoxy(1,1);write('GM Mode');
                                                 GMMode:=True;
                                            end
                                            else
                                                begin
                                                     textbackground(11);
                                                     gotoxy(1,1);write('       ');
                                                     GMMode:=False;
                                                end;
                                    end;
                            end;
                    end;
                 if (choice>1) and (key=#72) then
                    begin
                         gotoxy(43,8+choice*4);
                         textbackground(8);
                         textcolor(7);               
                         write(choicestring[choice]);
                         choice:=choice-1;           
                         gotoxy(43,8+choice*4);
                         textbackground(7);
                         textcolor(0);
                         write(choicestring[choice]);
                    end;
                 if (choice<3) and (key=#80) then
                    begin
                         gotoxy(43,8+choice*4);
                         textbackground(8);
                         textcolor(7);               
                         write(choicestring[choice]);
                         choice:=choice+1;
                         gotoxy(43,8+choice*4);
                         textbackground(7);
                         textcolor(0);
                         write(choicestring[choice]);
                    end;
           until (key=#13) or (key=#63);
           if key=#13 then
              case choice of
              1:
                begin
                     PlayMode;
                     choice:=1;
                end;
              2:
                begin
                     MapEditor;
                     choice:=2;
                end;
              3:
                begin
                     AboutGame;
                     choice:=3;
                end;
              end
              else
                  begin
                       ReadData;
                       if map_num>total then map_num:=total;
                  end;
           DrawSun;
     until False;
end.
