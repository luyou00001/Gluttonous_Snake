program Gluttonous_Snake;
uses crt;
var length,i,j,choice,map_num,score,speed,direction,temp,acceleration,head,item_num,enlarge,max,appear:integer;
    die,move,transfer:Boolean;
    item: array[1..5] of integer;
    wall,snake: array[1..760] of integer;
    key:char;

procedure Aboutgame;
begin
          gotoxy(21,3);write('             About the game             ');
          gotoxy(21,7);write('  Gluttonous Snake v1.1 by Sen Sen      ');
          gotoxy(21,8);write('                                        ');
          gotoxy(21,9);write('  Collaborator: Kobe Li                 ');
          gotoxy(21,11);write('  My website:                           ');
          gotoxy(21,12);write('  https://www.facebook.com/luyou001     ');
          gotoxy(21,13);write('                                        ');
          gotoxy(21,14);write('  My email: luyou00001@gmail.com        ');
          gotoxy(21,16);write('  Welcome for suggestions!              ');
          gotoxy(21,17);write('                                        ');
          gotoxy(21,18);write('                 ********               ');
          gotoxy(21,19);write('                 * ****                 ');
          gotoxy(21,20);write('                 ********               ');
          gotoxy(21,21);write('                 * * * *                ');
          gotoxy(21,22);write('                *  ** *                 ');
          gotoxy(21,23);write('               *   *    *  Press Enter  ');
          gotoxy(21,24);write('                                        ');
          repeat
                key:=readkey;
          until key= #13;
end;

procedure Enlargement;
begin
     length:=length+1;
     for j:= 1 to 760 do
         if snake[j]=length-1 then
            case direction of
            1:begin
                   if transfer then snake[j+720]:=length
                   else snake[j-40]:=length
              end;
            2:begin
                   if transfer then snake[j-720]:=length
                   else snake[j+40]:=length
              end;
            3:begin
                   if transfer then snake[j+39]:=length
                   else snake[j-1]:=length
              end;
            4:begin
                   if transfer then snake[j-39]:=length
                   else snake[j+1]:=length
              end;
            end;
     move:=False;
end;

procedure Show_Snake;
begin
     if acceleration>0 then textcolor(12)
        else textcolor(10);
     for i:= 1 to 760 do
         if snake[i]=-1 then
            begin
                 gotoxy(21 + (i-1) mod 40, 6 + (i-1) div 40 );write(' ');
                 snake[i]:=0;
            end;
     for i:= 1 to 760 do
         if (snake[i]>0) and (snake[i]<length) then
            begin
                 gotoxy(21 + (i-1) mod 40, 6 + (i-1) div 40 );write('*');
            end
         else if snake[i]=length then
            begin
                 gotoxy(21 + (i-1) mod 40, 6 + (i-1) div 40 );
                 if direction=1 then write('A');
                 if direction=2 then write('V');
                 if direction=3 then write('<');
                 if direction=4 then write('>');
            end;
     textcolor(15);
end;

function No_item:Boolean;
begin
     No_item:=True;
     for i:= 2 to 5 do
         if item[i]>0 then No_item:=False;
end;

procedure Show_Length;
begin
     textcolor(11);
     gotoxy(29,5);
     if length<10 then write('00',length)
        else if length<100 then write('0',length)
             else write(length);
     textcolor(10);
end;

procedure Show_Score;
begin
     textcolor(11);
     gotoxy(54,5);
     if score<10 then write('00000',score)
        else if score<100 then write('0000',score)
             else if score<1000 then write('000',score)
                  else if score<10000 then write('00',score)
                       else if score<100000 then write('0',score)
                            else write(score);
     textcolor(10);
end;

procedure Pause;
begin
     textcolor(11);
     gotoxy(21,5);write('   Pause...   Arrow keys for continue   ');
     repeat
           key:=readkey;
     until (key=#72) or (key=#80) or (key=#75) or (key=#77);
     gotoxy(21,5);write(' Length:000 X Speed:0000 X Score:000000 ');
     if speed<1000 then
        begin
             gotoxy(42,5);write(speed);
        end
     else
        begin
             gotoxy(41,5);write(speed);
        end;
     textcolor(10);
     Show_Score;
     Show_Length;
end;

procedure Pick_Object; //oaect
begin
     for i:= 1 to 5 do
         if item[i]=-1 then
            begin
                 case i of
                 1:
                   begin
                        enlarge:=enlarge+1;
                        if acceleration>0 then score:=score+(max*20*(1000+speed) div 1000)
                           else score:=score+(max*20*(1000+speed) div 2000);
                        item[i]:=0;
                   end;
                 2:
                   begin
                        acceleration:=speed div 5;
                        item[i]:=0;
                   end;
                 3:
                   begin
                        enlarge:=enlarge+5;
                        item[i]:=0;
                   end;
                 4:
                   begin
                        die:=True;
                        item[i]:=0;
                   end;
                 5:
                   begin
                        if acceleration>0 then score:=score+(max*100*(1000+speed) div 1000)
                           else score:=score+(max*100*(1000+speed) div 2000);
                        item[i]:=0;
                   end;
                 end;
             end;
end;

procedure Check_Pick;
begin
     for i := 1 to 5 do
         if head=item[i] then item[i]:=-1;
end;

procedure Gen_Food;
begin
     textcolor(14);
     if item[1]=0 then
        begin
             repeat
                   item[1]:=random(760)+1;
             until (snake[item[1]]=0) and (wall[item[1]]=0) and (item[1]<>item[2]) and (item[1]<>item[3]) and (item[1]<>item[4]) and (item[1]<>item[5]);
             gotoxy(21 + (item[1]-1) mod 40, 6 + (item[1]-1) div 40 );write('o');
        end;
     textcolor(15);
end; 

procedure Gen_Item;
begin
     if No_item then
        begin
             if acceleration>0 then item_num:=random(5 * speed div 5)+2
                else item_num:=random(5 * speed div 10)+2;
             if item_num<6 then
                begin
                     repeat
                           item[item_num]:=random(760)+1
                     until (snake[item[item_num]]=0) and (wall[item[item_num]]=0) and (item[item_num]<>item[1]);
                     gotoxy(21 + (item[item_num]-1) mod 40, 6 + (item[item_num]-1) div 40 );
                     textcolor(12);
                     case item_num of
                     2:write('a');
                     3:write('e');
                     4:write('d');
                     5:write('t');
                     end;
                     textcolor(10);
                     appear:=speed div 10;
                end;
        end;
end;

procedure Clear_Snake;
begin
     for i:= 1 to 760 do
         if (snake[i]>0) then
            begin
                 gotoxy(21 + (i-1) mod 40, 6 + (i-1) div 40 );write(' ');
            end;
end;

procedure Game_Over;
begin
     Clear_Snake;
     delay(200);
     Show_Snake;
     delay(200);
     Clear_Snake;
     delay(200);
     Show_Snake;
     delay(200);
     Clear_Snake;
     delay(200);
     Show_Snake;
     delay(200);
     temp:=length;
     for i:= 1 to length do
         begin
              delay(50);
              for j:= 1 to 760 do
                  if snake[j]=i then
                     begin
                          gotoxy(21 + (j-1) mod 40, 6 + (j-1) div 40 );write(' ');
                          score:=score+10*i;
                          Show_Score;
                     end;
         end;
     delay(1000);
     textcolor(10);
     gotoxy(21,6);write('                                        ');
     gotoxy(21,7);write('  Gluttonous Snake v1.1 by Sen Sen      ');
     gotoxy(21,8);write('                                        ');
      gotoxy(21,9);write('   XXX   XXX  X   X XXXXX               ');
     gotoxy(21,10);write('  X   X X   X XX XX X      Your Score:  ');
     gotoxy(21,11);write('  X XXX XXXXX X X X XXXXX               ');
     gotoxy(21,12);write('  X   X X   X X   X X                   ');
     gotoxy(21,13);write('   XXX  X   X X   X XXXXX  Final Length:');
     gotoxy(21,14);write('                                        ');
     gotoxy(21,15);write('   XXX  X   X XXXXX XXXX                ');
     gotoxy(21,16);write('  X   X X   X X     X   X  Map Number:  ');
     gotoxy(21,17);write('  X   X X   X XXXXX XXXX                ');
     gotoxy(21,18);write('  X   X  X X  X     X X                 ');
     gotoxy(21,19);write('   XXX    X   XXXXX X  XX               ');
     gotoxy(21,20);write('                                        ');
     gotoxy(21,21);write('                                        ');
     gotoxy(21,22);write('                                        ');
     gotoxy(21,23);write('              Press Enter to main menu  ');
     gotoxy(21,24);write('                                        ');
     gotoxy(48,11);write(score);
     gotoxy(48,14);write(max);
     gotoxy(48,17);write(map_num);
     if map_num=0 then write(' (No Map)');
     textcolor(15);
     repeat
           key:=readkey;
     until key= #13;
end;

procedure Snake_Move;
begin
     repeat
     move:=True;
     transfer:=False;
     if key=#112 then Pause;
     if key=#27 then
        begin
             die:=True;
             continue;
        end;
     if (key=#72) and (direction<>2) then direction:=1;
     if (key=#80) and (direction<>1) then direction:=2;
     if (key=#75) and (direction<>4) then direction:=3;
     if (key=#77) and (direction<>3) then direction:=4;
     case direction of
     1:
       begin
            if ((head <= 40) and ((snake[head+720]>0) or (wall[head+720]>0))) or ((head > 40) and ((snake[head-40]>0) or (wall[head-40]>0))) then die:=True
            else
                begin
                     if head > 40 then head:=head-40
                     else
                         begin
                              head:=head+720;
                              transfer:=True;
                         end;
                     Check_Pick;
                     Pick_Object;
                     if enlarge>0 then
                        begin
                             enlarge:=enlarge-1;
                             Enlargement;
                        end;
                     if move then
                        begin
                             for i:= 1 to 760 do if snake[i]=length then
                             begin
                                  if transfer then
                                     begin
                                          snake[i+720]:=length+1;
                                          transfer:=False;
                                     end
                                  else snake[i-40]:=length+1;
                             end;
                             for i:= 1 to 760 do if snake[i]=1 then snake[i]:=-1;
                             for i:= 1 to 760 do if snake[i]>0 then snake[i]:=snake[i]-1;
                        end;
                end;
       end;
     2:
       begin
            if ((head >= 721) and ((snake[head-720]>0) or (wall[head-720]>0))) or ((head < 721) and ((snake[head+40]>0) or (wall[head+40]>0))) then die:=True
            else
                begin
                     if head < 721 then head:=head+40
                     else
                         begin
                              head:=head-720;
                              transfer:=True;
                         end;
                     Check_Pick;
                     Pick_Object;
                     if enlarge>0 then
                        begin
                             enlarge:=enlarge-1;
                             Enlargement;
                        end;
                     if move then
                        begin
                             for i:= 1 to 760 do if snake[i]=length then
                             begin
                                  if transfer then
                                     begin
                                          snake[i-720]:=length+1;
                                          transfer:=False;
                                     end
                                  else snake[i+40]:=length+1;
                             end;
                             for i:= 1 to 760 do if snake[i]=1 then snake[i]:=-1;
                             for i:= 1 to 760 do if snake[i]>0 then snake[i]:=snake[i]-1;
                        end;
                end;
       end;
     3:
       begin
            if (((head-1) mod 40 = 0) and ((snake[head+39]>0) or (wall[head+39]>0))) or (((head-1) mod 40 > 0) and ((snake[head-1]>0) or (wall[head-1]>0))) then die:=True
            else
                begin
                     if (head-1) mod 40 > 0 then head:=head-1
                     else
                         begin
                              head:=head+39;
                              transfer:=True;
                         end;
                     Check_Pick;
                     Pick_Object;
                     if enlarge>0 then
                        begin
                             enlarge:=enlarge-1;
                             Enlargement;
                        end; 
                     if move then
                        begin
                             for i:= 1 to 760 do if snake[i]=length then
                             begin
                                  if transfer then
                                     begin
                                          snake[i+39]:=length+1;
                                          transfer:=False;
                                     end
                                  else snake[i-1]:=length+1;
                             end;
                             for i:= 1 to 760 do if snake[i]=1 then snake[i]:=-1;
                             for i:= 1 to 760 do if snake[i]>0 then snake[i]:=snake[i]-1;
                        end;
                end;
       end;
     4:
       begin
            if ((head mod 40 = 0) and ((snake[head-39]>0) or (wall[head-39]>0))) or ((head mod 40 > 0) and ((snake[head+1]>0) or (wall[head+1]>0))) then die:=True
            else
                begin
                     if head mod 40 > 0 then head:=head+1
                     else
                         begin
                              head:=head-39;
                              transfer:=True;
                         end;
                     Check_Pick;
                     Pick_Object;
                     if enlarge>0 then
                        begin
                             enlarge:=enlarge-1;
                             Enlargement;
                        end;
                     if move then
                        begin
                             for i:= 1 to 760 do if snake[i]=length then
                             begin
                                  if transfer then
                                     begin
                                          snake[i-39]:=length+1;
                                          transfer:=False;
                                     end
                                  else snake[i+1]:=length+1;
                             end;
                             for i:= 1 to 760 do if snake[i]=1 then snake[i]:=-1;
                             for i:= 1 to 760 do if snake[i]>0 then snake[i]:=snake[i]-1;
                        end;
                end;
       end;
     end;
     Show_snake;
     until True;
end;

procedure Action;
begin
     repeat
           if acceleration>0 then
              begin
                   temp:=25000 div speed;
                   acceleration:=acceleration-1;
              end
              else temp:=50000 div speed;
           if keypressed then
              repeat
                    key:=readkey;
              until not(keypressed);
           delay(temp);
           Snake_Move;
           Gen_Food;
           if appear=1 then
              begin
                   for i:= 2 to 5 do
                       if item[i]>0 then
                          begin
                               gotoxy(21 + (item[item_num]-1) mod 40, 6 + (item[item_num]-1) div 40 );write(' ');
                               item[i]:=0;
                               appear:=appear-1;
                          end;
              end
              else if appear>0 then appear:=appear-1;
           if (acceleration=0) and (enlarge=0) then Gen_Item;
           Show_Score;
           Show_Length;
           if max<length then max:=length;
     until die;
     Game_Over;
end;

procedure Create_Map;
begin
     textcolor(8);
     case map_num of
     1:
       for i:= 1 to 760 do
           case i of
           201..222,539..560,401..410,351..360,
           182,142,102,62,22,
           579,619,659,699,739,
           450,490,530,570,610,650,690,730,
           311,271,231,191,151,111,71,31:wall[i]:=1;
           end;
     end;
     for i:= 1 to 760 do
     if wall[i]=1 then
        begin
             gotoxy(21 + (i-1) mod 40, 6 + (i-1) div 40 );write('X');
        end;
     textcolor(15);
end;

procedure Play;
begin
     direction:=4;
     length:=6;
     enlarge:=0;
     acceleration:=0;
     max:=0;
     transfer:=False;
     die:=False;
     gotoxy(21,8);write('                                        ');
     gotoxy(21,12);write('                                        ');
     gotoxy(21,16);write('                                        ');
     textcolor(10);
     gotoxy(21,7);write('  *****>                                ');
     textcolor(11);
     gotoxy(31,5);write('6');
     textcolor(15);
     for i:= 1 to 760 do snake[i]:=0;
     for i:= 1 to 5 do item[i]:=0;
     for i:= 1 to 760 do wall[i]:=0;
     for i:= 1 to 6 do snake[42+i]:=i;
     head:=48;
     gotoxy(21,15);write(' The speed(use + or - to adjust): ',speed);
     repeat
           key:=readkey;
           if (key=#43) and (speed<991) then speed:=speed+10;
           if (key=#45) and (speed>109) then speed:=speed-10;
           gotoxy(55,15);write(speed);
           if speed<1000 then
              begin
                   gotoxy(58,15);write(' ');
              end;
     until key=#13;
     textcolor(11);
     if speed<1000 then
        begin
             gotoxy(42,5);write(speed);
        end
     else
        begin
             gotoxy(41,5);write(speed);
        end;
     textcolor(15);
     gotoxy(21,15);write(' The Map(use + or - to choose):         ');
     gotoxy(53,15);write(map_num);
     repeat
           key:=readkey;
           if (key=#43) and (map_num<2) then map_num:=map_num+1;
           if (key=#45) and (map_num>0) then map_num:=map_num-1;
           gotoxy(53,15);write(map_num);
     until key=#13;
     gotoxy(21,15);write('                                        ');
     Create_Map;
     textcolor(11);
     gotoxy(21,3);write('       Press right arrow to start       ');
     textcolor(15);
     repeat
           key:=readkey;
     until key=#77;
     direction:=4;
     gotoxy(21,3);write('   Gluttonous Snake  v1.1  by Sen Sen   ');
     Action;
end;

begin
     speed:=500;
     map_num:=0;
     repeat
           randomize;
           clrscr;
           gotoxy(1,1);
           textcolor(15);
           write('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');            {1}
           write('X                  X                                        X                  X');            {2}
           write('X    *********>    X   Gluttonous Snake  v1.1  by Sen Sen   X  Pickable Items  X');            {3}
           write('X    *             X                                        X ---------------- X');            {4}
           write('X    **********    X ');textcolor(11);write('Length:000 X Speed:0000 X Score:000000');textcolor(15);write(' X a: Acceleration  X');            {5}
           write('X             *    X                                        X (Speed*2 for 5s) X');            {6}
           write('X    **********    X                                        X                  X');            {7}
           write('X                  X Use arrow keys and Enter for selection X e: Enlargement   X');            {8}
           write('X    **********    X                                        X    (Length+5)    X');            {9}
           write('X    *             X                                        X                  X');            {10}
           write('X    *<********    X                                        X d: Die(refuse it)X');            {11}   {}
           write('X    *             X           -    Play now    -           X                  X');            {12}
           write('X    *********>    X                                        X t: Treasure      X');            {13}
           write('X                  X                                        X   (+Many score)  X');            {14}   {}
           write('X    ***      A    X                                        X                  X');            {15}
           write('X    * **     *    X             About the game             X o: Food          X');            {16}   {}
           write('X    *  ***   *    X                                        X   (+Few Score,   X');            {17}
           write('X    *    *** *    X                                        X     Length+1)    X');            {18}
           write('X    *      ***    X                                        X ---------------- X');            {19}   {}
           write('X                  X                                        X P:Pause          X');            {20}
           write('X                  X                                        X Arrow keys:      X');            {21}
           write('X   SEN SEN CHOI   X                                        X Continue         X');            {22}
           write('X                  X                                        X                  X');            {23}
           write('X                  X                                        X                  X');            {24}
           write('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');            {25}
           cursoroff;
           gotoxy(1,1);
           choice:=1;
           score:=0;
           repeat
                 key:=readkey;
                 if key=#72 then
                    begin
                         gotoxy(32,12);write('-');
                         gotoxy(49,12);write('-');
                         gotoxy(32,16);write(' ');
                         gotoxy(49,16);write(' ');
                         choice:=1;
                    end;
                 if key=#80 then
                    begin
                         gotoxy(32,16);write('-');
                         gotoxy(49,16);write('-');
                         gotoxy(32,12);write(' ');
                         gotoxy(49,12);write(' ');
                         choice:=2;
                    end;
           until key=#13;
           if choice=1 then Play;
           if choice=2 then Aboutgame;
     until False;
end.
