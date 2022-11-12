; RieStieDice.pb - Virtual Dice using OpenGL
; Copyright (C) 2022  Robert Stiegler
; 
; This program is free software: you can redistribute it And/Or modify
; it under the terms of the GNU General Public License As published by
; the Free Software Foundation, either version 3 of the License, Or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY Or FITNESS For A PARTICULAR PURPOSE.  See the
; GNU General Public License For more details.
; 
; You should have received a copy of the GNU General Public License
; along With this program.  If Not, see <https://www.gnu.org/licenses/>.


EnableExplicit


; ############ GL Procedures ############
 
Procedure GLResize(width.l, height.l)

 ResizeGadget(0, 1, 1, width, height)
 glViewport_(0,0,width,height)
 
 glMatrixMode_(#GL_PROJECTION)
 glLoadIdentity_()
 gluPerspective_(45.0,1,0.1,100.0)
 Define minlen.l 
 If width >= height : minlen = height
 Else : minlen = width : EndIf
 glScalef_(minlen/width, minlen/height, 1)

EndProcedure

Procedure GLInit()
  
  Protected Dim Ambient.f(4)
  Ambient(0) = 0.4
  Ambient(1) = 0.4
  Ambient(2) = 0.4
  Ambient(3) = 1.0
  
  Protected Dim Diffuse.f(4)
  Diffuse(0) = 1.0
  Diffuse(1) = 1.0
  Diffuse(2) = 1.0
  Diffuse(3) = 1.0
  
  Protected Dim Position.f(4)
  Position(0) = 0.0
  Position(1) = 2.0
  Position(2) = 2.0
  Position(3) = 1.0
  
  glEnable_(#GL_TEXTURE_2D)
  glEnable_(#GL_DEPTH_TEST)
  glEnable_(#GL_LIGHTING)
  glEnable_(#GL_CULL_FACE)   ; Only show the front of the cube side -> performance
  
  glDepthFunc_(#GL_LEQUAL)
  glShadeModel_(#GL_SMOOTH)
  glClearColor_(0.2, 0.2, 0.2, 0)
  glLightfv_(#GL_LIGHT1, #GL_POSITION, Position())
  glLightfv_(#GL_LIGHT1, #GL_DIFFUSE, Diffuse())
  glLightfv_(#GL_LIGHT1, #GL_AMBIENT, Ambient())
  glEnable_(#GL_LIGHT1)
  
EndProcedure

Procedure GLDrawCube(gadget.l, rot.f, dir.f, random.f)

  SetGadgetAttribute(gadget, #PB_OpenGL_SetContext, #True)
  
  glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
  glMatrixMode_(#GL_MODELVIEW)
  glLoadIdentity_()
  glTranslatef_(0.0, 0.0, -5)
  glRotatef_(rot, Cos(dir), Sin(dir), 0)
  glRotatef_(rot * random.f, 0, 0, 1)

  glBegin_(#GL_QUADS)
    ; Front
    glNormal3f_(0.0, 0.0, 1.0)
    glTexCoord2f_(0.0, 0.0) : glVertex3f_(-1.0, -1.0,  1.0)
    glTexCoord2f_(1.0, 0.0) : glVertex3f_( 1.0, -1.0,  1.0)
    glTexCoord2f_(1.0, 1.0) : glVertex3f_( 1.0,  1.0,  1.0)
    glTexCoord2f_(0.0, 1.0) : glVertex3f_(-1.0,  1.0,  1.0)
    ;Back
    glNormal3f_(0.0, 0.0,-1.0)
    glTexCoord2f_(1+1.0, 0.0) : glVertex3f_(-1.0, -1.0, -1.0)
    glTexCoord2f_(1+1.0, 1.0) : glVertex3f_(-1.0,  1.0, -1.0)
    glTexCoord2f_(1+0.0, 1.0) : glVertex3f_( 1.0,  1.0, -1.0)
    glTexCoord2f_(1+0.0, 0.0) : glVertex3f_( 1.0, -1.0, -1.0)
    ;Top
    glNormal3f_(0.0, 1.0, 0.0)
    glTexCoord2f_(2+0.0, 1.0) : glVertex3f_(-1.0,  1.0, -1.0)
    glTexCoord2f_(2+0.0, 0.0) : glVertex3f_(-1.0,  1.0,  1.0)
    glTexCoord2f_(2+1.0, 0.0) : glVertex3f_( 1.0,  1.0,  1.0)
    glTexCoord2f_(2+1.0, 1.0) : glVertex3f_( 1.0,  1.0, -1.0)
    ;Bottom
    glNormal3f_(0.0,-1.0, 0.0)
    glTexCoord2f_(3+1.0, 1.0) : glVertex3f_(-1.0, -1.0, -1.0)
    glTexCoord2f_(3+0.0, 1.0) : glVertex3f_( 1.0, -1.0, -1.0)
    glTexCoord2f_(3+0.0, 0.0) : glVertex3f_( 1.0, -1.0,  1.0)
    glTexCoord2f_(3+1.0, 0.0) : glVertex3f_(-1.0, -1.0,  1.0)
    ;Right
    glNormal3f_(1.0, 0.0, 0.0)
    glTexCoord2f_(4+1.0, 0.0) : glVertex3f_( 1.0, -1.0, -1.0)
    glTexCoord2f_(4+1.0, 1.0) : glVertex3f_( 1.0,  1.0, -1.0)
    glTexCoord2f_(4+0.0, 1.0) : glVertex3f_( 1.0,  1.0,  1.0)
    glTexCoord2f_(4+0.0, 0.0) : glVertex3f_( 1.0, -1.0,  1.0)
    ;Left
    glNormal3f_(-1.0, 0.0, 0.0)
    glTexCoord2f_(5+0.0, 0.0) : glVertex3f_(-1.0, -1.0, -1.0)
    glTexCoord2f_(5+1.0, 0.0) : glVertex3f_(-1.0, -1.0,  1.0)
    glTexCoord2f_(5+1.0, 1.0) : glVertex3f_(-1.0,  1.0,  1.0)
    glTexCoord2f_(5+0.0, 1.0) : glVertex3f_(-1.0,  1.0, -1.0)
  glEnd_()

  SetGadgetAttribute(gadget, #PB_OpenGL_FlipBuffers, #True)
  
EndProcedure

Procedure GLApplyImageToCube(img)
  Static DiceTexture.l
  Protected *pointer = EncodeImage(img, #PB_ImagePlugin_BMP) 
  
  If Not glIsTexture_(DiceTexture) : glGenTextures_(1, @DiceTexture) : EndIf
  glBindTexture_(#GL_TEXTURE_2D, DiceTexture)
  glTexParameteri_(#GL_TEXTURE_2D,#GL_TEXTURE_MAG_FILTER,#GL_LINEAR)
  glTexParameteri_(#GL_TEXTURE_2D,#GL_TEXTURE_MIN_FILTER,#GL_LINEAR)
  glTexImage2D_(#GL_TEXTURE_2D, 0, 3,ImageWidth(img),ImageHeight(img), 0, #GL_BGR_EXT, #GL_UNSIGNED_BYTE, *pointer+54);
  glMatrixMode_(#GL_TEXTURE)
  glLoadIdentity_()
  glScaled_(1.0/6.0, 1, 1)
  FreeMemory(*pointer)
EndProcedure


; ############ Helper procedures ############

Procedure.l ReadLinesFromFile(Path.s, Array Lines.s(1))
  Debug Path
  
  If Path = "" : ProcedureReturn -1 : EndIf
  If FileSize(Path) <= 0 : ProcedureReturn -2 : EndIf
  
  Protected File = OpenFile(#PB_Any, Path, #PB_File_SharedRead)
  Protected LineNr.l = 0
  Protected Line.s = ReadString(File)
  While Line.s And LineNr < ArraySize(Lines())
    Lines(LineNr) = Line
    LineNr + 1
    Line = ReadString(File)
  Wend
  CloseFile(File)
  
  ProcedureReturn LineNr
EndProcedure


; ############ Modules ############

DeclareModule Config
  
  #Config_RecentFiles_Max = 10
  
  Structure ConfigStruct
    ; Window configs
    ; WindowX.l
    ; WindowY.l
    ; WindowWidth.l
    ; WindowHeight.l
    
    ; Font settings
    FontName.s
    FontSize.l
    
    ; Current settings
    NoRepetition.a
    NoAnimation.a
    
    ; Recent Files
    List RecentFiles.s()
  EndStructure
  Define config.ConfigStruct 
  
  Declare Load()
  Declare Store()
  Declare AddRecentFilePath(FilePath.s)
  
EndDeclareModule

Module Config
  EnableExplicit
  
  #Config_JSON_Path = "config.cfg"
  
  ; Load default values
  Config::config\NoRepetition = 1
  Config::config\NoAnimation = 0
  
  Config::config\FontName = "Arial"
  Config::config\FontSize = 36
  
  Procedure Load()
    Protected json = LoadJSON(#PB_Any, #Config_JSON_Path)
    If json
      ExtractJSONStructure(JSONValue(json), Config::@config, ConfigStruct, #PB_JSON_NoClear)
      FreeJSON(json)
    EndIf
  EndProcedure
  
  Procedure Store()
    Protected json = CreateJSON(#PB_Any)
    If  json
      InsertJSONStructure(JSONValue(json), Config::@config, ConfigStruct)
      SaveJSON(json, #Config_JSON_Path, #PB_JSON_PrettyPrint)
      FreeJSON(json)
    EndIf
  EndProcedure  
  
  Procedure AddRecentFilePath(FilePath.s)
    ; See if element was in the list already
    ResetList(Config::config\RecentFiles())
    While NextElement(Config::config\RecentFiles())
      If Config::config\RecentFiles() = FilePath
        MoveElement(Config::config\RecentFiles(), #PB_List_First)
        ProcedureReturn
      EndIf
    Wend
    
    ; Otherwise add new element to beginning of list
    FirstElement(Config::config\RecentFiles()) : InsertElement(Config::config\RecentFiles()) : Config::config\RecentFiles() = FilePath
    
    ; Trim list if too long
    If ListSize(Config::config\RecentFiles()) > Config::#Config_RecentFiles_Max 
      LastElement(Config::config\RecentFiles()) : DeleteElement(Config::config\RecentFiles())
    EndIf
    
  EndProcedure

EndModule


DeclareModule Dice
  
  #Dice_Sides_Max = 100
  #Dice_Sides_Min = 2
  
  Enumeration
    #State_Ready = 0
    #State_Rolling
  EndEnumeration
  
  Structure DiceStruct
    DefaultState.l
    ActiveSides.l
    Array Texts.s(#Dice_Sides_Max-1)
    List TextsLeft.l()
    
    AnimationRunning.l
    AnimationStartTick.l
    AnimationAngle.f
    AnimationSpeed.f
    AnimationRandom.f
  EndStructure
  
  Structure DiceState
    AnimationRunning.l
    AnimationRotation.f
  EndStructure
  
  Declare LoadDefaultDice(*dice.DiceStruct)
  Declare.l LoadDice(*dice.DiceStruct, Array Texts.s(1), Elements.l)
  
  Declare.l RollTheDice(*dice.DiceStruct, NoRepetition.l)
  Declare.l GetDiceImage(*dice.DiceStruct, frontTextIndex.l)
  
  Declare AnimationStart(*dice.DiceStruct, GameTick.l, Animation.l = #True)
  Declare AnimationUpdate(*dice.DiceStruct, GameTick.l, *ret.DiceState)
  
EndDeclareModule

Module Dice
  EnableExplicit
  
  Global i.l, j.l
  
  Global Dim ColorTable(5)
  ColorTable(0) = #Green
  ColorTable(1) = #Blue
  ColorTable(2) = #Yellow
  ColorTable(3) = #Red
  ColorTable(4) = $00A5FF
  ColorTable(5) = $CC3299
  
  #ImageSize = 512
  #CubeBorder = #ImageSize / 20.0
  
  #CubeAnimationDuration = 1700
  #CubeAnimationMaxSpeed = 2000
  #CubeAnimationMinSpeed = 1600

  Declare DrawTextEx(X.l, Y.l, Width.l, Height.l, Text.s, Font.l, FrontColor.l = #Black, Margin.l = 5, BorderColor.l = -1, HAlign.l = -1, VAlign.l = -1)      
  Declare NextElementCycle(List lst())
  
  Procedure LoadDefaultDice(*dice.DiceStruct)
    *dice\ActiveSides = 6
    *dice\DefaultState = 1
  EndProcedure
  
  Procedure.l LoadDice(*dice.DiceStruct, Array Texts.s(1), Elements.l)
    If (Elements < #Dice_Sides_Min) Or (Elements > #Dice_Sides_Max) Or (ArraySize(Texts()) < Elements) : ProcedureReturn 0 : EndIf  
    CopyArray(Texts(), *dice\Texts())    
    ClearList(*dice\TextsLeft())
    *dice\ActiveSides = Elements
    *dice\DefaultState = 0
    ProcedureReturn 1
  EndProcedure
  
  Procedure.l RollTheDice(*dice.DiceStruct, NoRepetition.l)
    If ListSize(*dice\TextsLeft()) = 0 Or Not NoRepetition
      ClearList(*dice\TextsLeft())
      For i = 0 To *dice\ActiveSides - 1
        AddElement(*dice\TextsLeft()) : *dice\TextsLeft() = i
      Next
    EndIf
    RandomizeList(*dice\TextsLeft())
    FirstElement(*dice\TextsLeft())
    Define NextText.l = *dice\TextsLeft()
    Debug "Selected Text " + Str(NextText) + " out of " + Str( ListSize(*dice\TextsLeft()) )  + " Elements"
    
    If NoRepetition
      DeleteElement(*dice\TextsLeft())
    EndIf
    
    ProcedureReturn NextText
    
  EndProcedure
  
  Procedure.l GetDiceImage(*dice.DiceStruct, frontTextIndex.l)
    Static img.l = 0
    
    If Not IsImage(img) 
      img = CreateImage(#PB_Any, #ImageSize * 6, #ImageSize) 
    EndIf
        
    NewList RemainingTexts()
    For i = 0 To *dice\ActiveSides - 1
      If i <> frontTextIndex
        AddElement(RemainingTexts()) 
        RemainingTexts() = i 
      EndIf
    Next
    RandomizeList(RemainingTexts())
    
    Dim CubeFaceTexts.l(5)
    CubeFaceTexts(0) = frontTextIndex
    FirstElement(RemainingTexts())
    For i = 1 To 5
      CubeFaceTexts(i) = RemainingTexts()
      NextElementCycle(RemainingTexts())
      ;Debug "Side " + Str(i) + ": " + *dice\Texts( CubeFaceTexts(i))
    Next
    
    If StartDrawing(ImageOutput(img))
      For i = 0 To 5
        Box(i * #ImageSize, 0, #ImageSize, #ImageSize, #Black)
        Box(i * #ImageSize + #CubeBorder, #CubeBorder, #ImageSize-2*#CubeBorder, #ImageSize-2*#CubeBorder, #White)
        If *dice\DefaultState = 0
          DrawTextEx(i * #ImageSize, 0, #ImageSize, #ImageSize, *dice\Texts(CubeFaceTexts(i)) , 0, #Black, #CubeBorder, -1, 0, 0)
        Else
          Box(i * #ImageSize + #CubeBorder, #CubeBorder, #ImageSize-2*#CubeBorder, #ImageSize-2*#CubeBorder, ColorTable(CubeFaceTexts(i)))
        EndIf
      Next
    StopDrawing() : EndIf
      
    ProcedureReturn img
  EndProcedure
  
  
  Procedure AnimationStart(*dice.DiceStruct, GameTick.l, Animation.l = #True)
    If *dice\AnimationRunning = #True : ProcedureReturn : EndIf
    
    *dice\AnimationAngle = Radian(Random(360))
    *dice\AnimationSpeed = Random(#CubeAnimationMaxSpeed, #CubeAnimationMinSpeed) * 0.0000004
    *dice\AnimationRandom = Random(2000) * 0.001 - 1.0 
    If Animation
      *dice\AnimationStartTick = GameTick
      *dice\AnimationRunning = #True
    Else 
      *dice\AnimationStartTick = -10000
      *dice\AnimationRunning = #False
    EndIf
  EndProcedure
  
  Procedure AnimationUpdate(*dice.DiceStruct, GameTick.l, *ret.DiceState)
    Define animation = #CubeAnimationDuration - (GameTick-*dice\AnimationStartTick)
    If *dice\AnimationRunning = #True 
      If animation < 0 ; Animation ended
        *dice\AnimationRunning = #False
      EndIf
    EndIf
      
    If *dice\AnimationRunning = #True
      *ret\AnimationRotation  = 0.5 * *dice\AnimationSpeed * Pow(animation,2)
    Else
      *ret\AnimationRotation = 0
    EndIf
    
    *ret\AnimationRunning = *dice\AnimationRunning  
  EndProcedure
  
  

  Procedure DrawTextEx(X.l, Y.l, Width.l, Height.l, Text.s, Font.l, FrontColor.l = #Black, Margin.l = 5, BorderColor.l = -1, HAlign.l = -1, VAlign.l = -1)                     
    Protected NewList Words.s()
    Protected NewList Lines.s()
  
    Text = ReplaceString(Text, Chr(10), " " + Chr(10) + " ")
    ; Remove double spaces
    Protected i
    For i = 0 To 5 
      Text = ReplaceString(Text, "  ", " ")
    Next
    Text = Trim(Text)
    
    ; Split words by space charakter
    Protected k = 1
    Protected word.s = StringField(Text, k, " ")
    While word <> ""
      AddElement(Words())
      Words() = word
      k + 1
      word = StringField(Text, k, " ")
    Wend
    
    If Margin : X + Margin : Y + Margin : Width - (2*Margin) : Height - (2*Margin) : EndIf
    If Text = "" : ProcedureReturn : EndIf
    If width <= 0 Or height <= 0 Or height <= TextHeight(Text) : ProcedureReturn : EndIf 
    
    ; Words to lines
    DrawingFont(FontID(font))
    AddElement(Lines())
    ForEach Words()
      If Words() = Chr(10)
        Lines() = Trim(Lines())
        AddElement(Lines())
      Else
        If TextWidth(Lines() + Words()) > Width And Len(Lines()) > 0
          Lines() = Trim(Lines())
          AddElement(Lines()) 
        EndIf
        Lines() = Lines() + Words() + " "
      EndIf
    Next
    
    ; Draw lines
    Protected.l PosX, PosY
    Protected LineHeight = TextHeight("0")
    DrawingMode(#PB_2DDrawing_Transparent)
    
    If VAlign = 0
      PosY = Y + Height / 2 - (LineHeight * ListSize(Lines())) / 2
    ElseIf Valign > 0
      PosY = Y + Height - (LineHeight * ListSize(Lines()))
    Else
      PosY = y
    EndIf
    
    ForEach Lines()
      If HAlign = 0
        PosX = X + Width / 2 - TextWidth(Lines()) / 2
      ElseIf HAlign > 0
        PosX = X + Width - TextWidth(Lines())
      Else
        PosX = X
      EndIf  
      DrawText(PosX, PosY, Lines(), FrontColor)
      PosY + LineHeight
    Next
    
     If BorderColor <> -1
       DrawingMode(#PB_2DDrawing_Outlined)
       Box(x,y,width,PosY-y, BorderColor)
     EndIf
     
  EndProcedure 

  Procedure NextElementCycle(List lst())
    If Not NextElement(lst()) 
      ResetList(lst())
      NextElement(lst())
    EndIf  
  EndProcedure

EndModule





Define i

Enumeration
  #MenuItem_Open = 1
  #MenuItem_NoRepeatition = 2
  #MenuItem_NoAnimation = 3
  #MenuItem_Close = 9
  #MenuItem_RecentOffset = 10
  ; Recent Files = 10 - x
EndEnumeration

Define dice.Dice::DiceStruct
Define ds.Dice::DiceState




  
OpenWindow(0, 0, 0, 640, 480, "RieStie Dice",#PB_Window_MinimizeGadget |  #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered ) 
OpenGLGadget(0, 0, 0, 640, 480, #PB_OpenGL_Keyboard) : SetActiveGadget(0)

Config::Load()
If Not LoadFont(0, Config::config\FontName, Config::config\FontSize)
  MessageRequester("Error", "Font " + Config::config\FontName + " not found")
EndIf

Dice::LoadDefaultDice(@dice)
GLInit()
GLApplyImageToCube(Dice::GetDiceImage(@dice, Dice::RollTheDice(@dice, Config::config\NoRepetition)))   
GLResize(640, 480)



Dim TextsBuffer.s(1000)
Define GameTick.l
Define WE.l
Define EM.l
Define Quit.l
Define Lines.l

Repeat
  GameTick = ElapsedMilliseconds()
  Dice::AnimationUpdate(@dice, GameTick, @ds)

  Repeat 
    WE = WindowEvent()
    Select WE
        
      Case #PB_Event_CloseWindow
        Quit = 1
        
      Case #PB_Event_SizeWindow  
        GLResize(WindowWidth(0),WindowHeight(0))
        
      Case #PB_Event_Menu
        EM = EventMenu()
        If EM = #MenuItem_Close
          Quit = 1
          
        ElseIf EM = #MenuItem_Open
          Define FilePath.s
          If FirstElement(Config::config\RecentFiles()) 
            FilePath = OpenFileRequester("Open Dice Wordlist", Config::config\RecentFiles(), "Wordlist | *.txt", 0) 
          Else
            FilePath = OpenFileRequester("Open Dice Wordlist", GetCurrentDirectory(), "Wordlist | *.txt", 0) 
          EndIf 
          
          If FilePath <> ""
            If Dice::LoadDice(@dice, TextsBuffer(), ReadLinesFromFile(FilePath, TextsBuffer()))
              GLApplyImageToCube(Dice::GetDiceImage(@dice, 0))
              Config::AddRecentFilePath(FilePath)
            Else
              MessageRequester("Error", "Could not load file " + Config::config\RecentFiles(), #PB_MessageRequester_Warning)
            EndIf
          EndIf  
            
        ElseIf EM = #MenuItem_NoRepeatition
          Config::config\NoRepetition = Bool(Not Config::config\NoRepetition)
          
        ElseIf EM = #MenuItem_NoAnimation
          Config::config\NoAnimation = Bool(Not Config::config\NoAnimation)
          
        ElseIf EM >= #MenuItem_RecentOffset
          If SelectElement(Config::config\RecentFiles(), EM - #MenuItem_RecentOffset)
            If Dice::LoadDice(@dice, TextsBuffer(), ReadLinesFromFile(Config::config\RecentFiles(), TextsBuffer()))
              GLApplyImageToCube(Dice::GetDiceImage(@dice, 0))
              Config::AddRecentFilePath(Config::config\RecentFiles())
            Else
              MessageRequester("Error", "Could not load file " + Config::config\RecentFiles(), #PB_MessageRequester_Warning)
              DeleteElement(Config::config\RecentFiles())
            EndIf
          EndIf
        EndIf
        
      Case #PB_Event_Gadget
        Select EventType() 
          Case #PB_EventType_RightClick  
            CreatePopupMenu(0)
              MenuItem(#MenuItem_Open, "Open")
              OpenSubMenu("Open Recent")
              For i = 0 To ListSize(Config::config\RecentFiles()) - 1
                SelectElement(Config::config\RecentFiles(), i)
                MenuItem(#MenuItem_RecentOffset+i, Config::config\RecentFiles())
              Next
              CloseSubMenu()
              MenuBar()
              MenuItem(#MenuItem_NoRepeatition, "No repeatition")
              MenuItem(#MenuItem_NoAnimation, "No Animation")
              MenuBar()
              MenuItem(#MenuItem_Close, "Close")
            SetMenuItemState(0, #MenuItem_NoRepeatition, Config::config\NoRepetition)   
            SetMenuItemState(0, #MenuItem_NoAnimation, Config::config\NoAnimation)  
            
            DisplayPopupMenu(0, WindowID(0)) 
            FreeMenu(0)
          Case #PB_EventType_LeftClick
            If ds\AnimationRunning = #False
              GLApplyImageToCube(Dice::GetDiceImage(@dice, Dice::RollTheDice(@dice, Config::config\NoRepetition)))   
              Dice::AnimationStart(@dice, GameTick, Bool(Not Config::config\NoAnimation))
            EndIf
          Case #PB_EventType_KeyDown
            Define Key = GetGadgetAttribute(0, #PB_OpenGL_Key)
            If Key = #PB_Shortcut_Escape
              Quit = 1
            ElseIf Key = #PB_Shortcut_Space Or Key = #PB_Shortcut_Return
              If ds\AnimationRunning = #False
                GLApplyImageToCube(Dice::GetDiceImage(@dice, Dice::RollTheDice(@dice, Config::config\NoRepetition)))   
                Dice::AnimationStart(@dice, GameTick, Bool(Not Config::config\NoAnimation))
              EndIf
            EndIf
          EndSelect

    EndSelect
  Until WE = 0 Or Quit = 1
  
  GLDrawCube(0, ds\AnimationRotation, dice\AnimationAngle, dice\AnimationRandom)
  
  Delay(1)
Until Quit = 1

Config::Store()


; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 108
; FirstLine = 3
; Folding = EO00
; Optimizer
; EnableThread
; EnableXP
; UseIcon = ..\..\..\Downloads\favicon(1).ico
; Executable = RieStieDice.exe