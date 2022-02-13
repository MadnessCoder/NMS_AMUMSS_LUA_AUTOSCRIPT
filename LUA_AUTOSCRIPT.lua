-- Hello there!
-- This script is noob friendly. You can easily learn something new by reading comments.

-- Version 1.0_aka_12.02.2022
-- NMS version: 3.75

-- Script author: Vasiliy
-- License: GPL-2.0-only


-- INPUT
--==================================================================================
Path = "" -- Defines the path from where we get comparable EXML files. Both should be in the same folder. Remember, every \\ = \
Original_EXML_name = "Original_TEST.EXML"
Modified_EXML_name = "Modified_TEST.EXML"

Modified_EXML_name_cut = string.sub(Modified_EXML_name,1,#Modified_EXML_name-5) -- don't touch it.
--==================================================================================



-- Architecture of the script.
--==================================================================================
-- In the top of the script: container templates and general helpers.
-- 
-- For scalability and readability every part (e.g., every algorithm) should contain its own objects to work with.
-- It could be done in a manner where Walker and NodeList contain all attributes, but it quickly lead to obfuscated code.
-- 
-- The architecture of meta-algorithm.
-- 1. Read every line.
-- 2. If graph for Deep First Search (DFS) exists, perform DFS.
-- 3. If lines are different, perform Graph Root Search algorithm.
-- 4. During traversing to the root extract all needed names/values.
-- 5. Write extracted names/values to new file.
--==================================================================================

-- TODO list
--====================================
-- 1. Implement a visitor pattern.
--  	every nested algorithm should have its own walker with appropriate attributes.
-- 2. Create getter and setter interfaces.
--====================================

-- Open Questions.
--====================================
-- How to create a visitor pattern?
-- How to reduce the number of "if" statements (conditions) in proper way?
-- Is it resource intensive?
-- Does anyone want to generalize it to the case of created/deleted lines in documents?
-- Does anyone want to add some proven robustness (and, firstly, prove it)?
--====================================



-- MOD_AUTOSCRIPT_MAIN_1 = the very beginning of the new script file. Consists of two parts.
MOD_AUTOSCRIPT_MAIN_1_1 =
[[NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"]	= "]]

MOD_AUTOSCRIPT_MAIN_1_2 =
[[",
["MOD_AUTHOR"]		= "VASILIY_AUTOSCRIPT",
["NMS_VERSION"]		= "3.75",
["MOD_DESCRIPTION"]	= "",
["MODIFICATIONS"]	= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.59B126E2.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "GCPLAYERGLOBALS.GLOBAL.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
]]

MOD_AUTOSCRIPT_BODY_1 =
[[							["PRECEDING_KEY_WORDS"] 	= {]]

MOD_AUTOSCRIPT_BODY_1_CLOSURE =[[},
]]


MOD_AUTOSCRIPT_BODY_2 =
[[						{
							["VALUE_CHANGE_TABLE"] 		= 
							{
								{]]

MOD_AUTOSCRIPT_BODY_2_CLOSURE =
[[},
							}
						},
]]

-- MOD_AUTOSCRIPT_MAIN_2 = the very ending of the new script file.
MOD_AUTOSCRIPT_MAIN_2 =
[[					}
				}
			}
		}
	}	
}	
]]

-- glb_SCRIPT_OTPUT = {} -- Alternative method. Is needed to combine all parts of the script. First of all because of the containers.


-- General Helpers
--====================================
function ParseTextFileIntoTable(AnyFile) -- Reads given file and makes a lua_table from it. 
	local Filehandle = io.open(AnyFile, 'r')
	LineTable = {}
	local Line = Filehandle:read("*line")
	while Line ~= nil do
		table.insert(LineTable, Line) 
		Line = Filehandle:read("*line")
	end
	Filehandle:close()	
	return LineTable
end

function createNewFile(Output,FileName) -- Creates a file and writes smth in it. Is needed to erase everythig and begin new file.
	local Filehandle = io.open(FileName .. "_AUTOSCRIPT.lua", 'w')
	Filehandle:write(Output)
	Filehandle:flush()
	Filehandle:close()
end

function writeToFile(Output,FileName) -- Writes something in existed file. Just appends output values to the end of a file.
	local Filehandle = io.open(FileName .. "_AUTOSCRIPT.lua", 'a')
	Filehandle:write(Output)
	Filehandle:flush()
	Filehandle:close()
end


function writeToFileCSV(Output,FileName) -- CSV = comma separated values. Adds commas betwean output values. Writes something in existed file. Just appends output values to the end of a file.
	local Filehandle = io.open(FileName .. "_AUTOSCRIPT.lua", 'a')
	if type(Output) == table then
		for i = 1, Output do
			Filehandle:write(Output[i])
			Filehandle:write(", ")
		end
	else
		Filehandle:write(Output)
		Filehandle:write(", ")
	end
	Filehandle:flush()
	Filehandle:close()
end
--====================================
 
 
 
 -- Main function!
 function CreateNewScript(Original_EXML_name,Modified_EXML_name)
	local ScriptOutput = ""
	glb_TextFileTableVanilla = ParseTextFileIntoTable(Original_EXML_name) -- Global! Creates lua_table from files for further work
	glb_TextFileTableMod = ParseTextFileIntoTable(Modified_EXML_name) -- Global! Creates lua_table from files for further work
	createNewFile(MOD_AUTOSCRIPT_MAIN_1_1, Modified_EXML_name_cut)
	writeToFile(Modified_EXML_name_cut .. ".pak", Modified_EXML_name_cut)
	writeToFile(MOD_AUTOSCRIPT_MAIN_1_2, Modified_EXML_name_cut)
	glb_CurrentLine = 3 -- Global! Properties begin after 3d line in documents.
	while glb_CurrentLine ~= #glb_TextFileTableVanilla+1 do
		glb_Tesei = Walker(glb_CurrentLine) -- Global!
		glb_NodeList = nil -- Global!
		DFS()
		glb_CurrentLine = glb_CurrentLine + glb_Tesei.getLastNodeIndex()
	end
	writeToFile(MOD_AUTOSCRIPT_MAIN_2, Modified_EXML_name_cut)
 end
 



-- Deep First Search   and   Graph Root Search   algorithms
--==================================================================================
-- DFS
--==================================================================================
-- Google for Deep First Search for more info.


-- this algorithm was to difficult to implement it with up-to-down either down-to-top architecture. Had to use OOP instead.

--==================================================================================
-- (Cool) Story (no need to read this part)
-- At first look this task was very easy. Tried to come up with principal scheme of algorithm that would find and insert preceding(special) keywords in new script.
-- Suddenly, operative memory size of my brain was to low to draw it. Then i decided to go another way and use induction approach (down-to-top).
-- It helped with low operative memory size, though I had to create a lot of probabal next steps in the scheme.
-- After some hours of tryings it was obvious that i have to apply something new. Started to explore any new approach.
-- Suddenly it appeared to me that Object-Oriented Programming is about down-to-top and top-to-down approach. It is in between of them.
-- You can call me stupid, but that wasn't obvious for me :D  Thougt about OOP as smth else, that solves other problems, not this one.
-- A-and, after realizing that brainless OOP can solve my problem, I started to create objects and decide what to do next step-by-step.
-- Still i had to do smth with the algorithm, even after i divided it into parts. Started research again and found out that this is Depth First Algorithm (DFS) that i was trying to implement.
-- This knowledge helped me a lot. Though i already was exhausted and had a lot of redundant information about how to do it in my head.
-- Now i understood that there is a tree of decisions and this made it possible to create the principal scheme. Just use graph and that's it.
-- Suddenly! (again, yea), i realized that was writing a bot (agent, actor)! That was a breakthrough. 
-- Graph represents Markov chains. Actor is multi-armed bandit (see Gittins index).
-- It was big unfortune that i didn't think about graph and related mathematics at all in the beginning. Since I realized it is an actor, the principal scheme had become obvious and simple.
-- It is just an actor that has set of actions and a modeled environment where it can do that actions. That's it.
-- So. The good decision is to model an environment firstly. Then create actions which apply to this environment. And lastly to provide actor with theese actions and let him "go".
-- Programmers also call this visitor pattern.

-- Unfortanately, i had already made a lot at that moment. And I just want it to work. That's why you can see appropriate duct tapes in DFS code.
-- The main part is done: it is research, first of all, and working implemenation. Feel free to improve the code.
-- (some time later)
-- Rewrote this part from scratch. Still, code review and improvements are welcome.
--==================================================================================


-- During DFS two exml files are compared.
-- When DFS finds difference in lines, it launches another algorithm without interupting.
-- Another algorithm is called Graph Root Search. 
-- Graph Root Search goes up to the root and extracts all names and/or values that represent subsections.
-- When GRS is done, DFS resumes its work.

-- There is environment(glb_NodeList). There is set of actions(methods). There is an actor(Walker).

-- Legend.
-- LastNodeIndex AKA LastDFSLineNum
-- NodeIndex AKA CurrentDFSLineNum
-- glb_NodeList AKA Environment
-- Flags tell about walker have already gone this way.
-- CurrentNodeIndex defines the node in which walker is right now.

function Walker(StartLineNum)
	-- Table of attributes.
	local self = 	{
					CurrentNodeIndex 	= 0,
					LastNodeIndex 		= 0,
					StartLineNum		= StartLineNum, -- Line number before DFS starting
					PreviousVisitedNode = 0 -- needed to implement Graph Root Search
					}
					
	-- Methods
	local function increaseLastNodeIndex()
		self.LastNodeIndex = self.LastNodeIndex+1
	end
	
	local function setCurrentNodeIndex(CurrentNodeIndex)
		self.CurrentNodeIndex = CurrentNodeIndex
	end
	
	local function setPreviousVisitedNode(PreviousVisitedNode)
		self.PreviousVisitedNode = PreviousVisitedNode
	end
	
	local function teleportTo(WantedNodeIndex) -- same as setCurrentNodeIndex
		self.CurrentNodeIndex = WantedNodeIndex
	end
	
	-- These methods should be in the outside interface (Walker.get or getter)
	--=========
	local function getCurrentNodeIndex()
		return self.CurrentNodeIndex
	end
	
	local function getLastNodeIndex()
		return self.LastNodeIndex
	end
	
	local function getStartLineNum()
		return self.StartLineNum
	end
	
	local function getPreviousVisitedNode()
		return self.PreviousVisitedNode
	end
	--=========

	
	-- These methods should be in the outside interface (Movement)
	--=========
	local function goRightAndDown()
		if glb_NodeList == nil then
			glb_NodeList = {}
			table.insert(glb_NodeList, Node(glb_Tesei.getCurrentNodeIndex(), 1))
			glb_Tesei.setCurrentNodeIndex(glb_Tesei.getLastNodeIndex()+1)
			glb_Tesei.increaseLastNodeIndex()
			if LinesDifferent(glb_Tesei.getStartLineNum()+glb_Tesei.getCurrentNodeIndex()) == true then
				glb_FoundKeysAndValuesTable = nil 
				glb_ConvertedKeysAndValuesTable = {}
				GraphRootSearch()
			end
			-- glb_Tesei.setPreviousVisitedNode(glb_Tesei.getCurrentNodeIndex) -- Redundant
			DFS()
		elseif glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getFlag_RightAndDown() == 0 then
			glb_NodeList[glb_Tesei.getCurrentNodeIndex()].toggleFlag_RightAndDown()	
			if checkRightAndDown() == true then
				table.insert(glb_NodeList, Node(glb_Tesei.getCurrentNodeIndex(),glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getCounter_RightAndDown()+1))
				-- glb_NodeList[#glb_NodeList+1]=Node(glb_Tesei.getCurrentNodeIndex(),glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getCounter_RightAndDown()+1) -- Alternate method.
				glb_Tesei.setCurrentNodeIndex(glb_Tesei.getLastNodeIndex()+1)
				glb_Tesei.increaseLastNodeIndex()
				if LinesDifferent(glb_Tesei.getStartLineNum()+glb_Tesei.getCurrentNodeIndex()) == true then
					glb_FoundKeysAndValuesTable = nil 
					glb_ConvertedKeysAndValuesTable = {}
					GraphRootSearch()
				end
				-- glb_Tesei.setPreviousVisitedNode(glb_Tesei.getCurrentNodeIndex) -- Redundant
				DFS()
			end
		end 
	end
	
	local function goDownStraight()
		if glb_Tesei.getCurrentNodeIndex() ~= 0 and glb_Tesei.getCurrentNodeIndex() ~= 1 then -- to prevent DownStraight moving in null and first nodes. First node is pseudo-null node.
			if glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getFlag_DownStraight() == 0 then
				glb_NodeList[glb_Tesei.getCurrentNodeIndex()].toggleFlag_DownStraight()	
				if checkDownStraight() == true then
					table.insert(glb_NodeList, Node(glb_Tesei.getCurrentNodeIndex(),glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getCounter_RightAndDown()))
					-- glb_NodeList[#glb_NodeList+1]=Node(glb_Tesei.getCurrentNodeIndex(),glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getCounter_RightAndDown()) -- Alternate method.
					glb_Tesei.setCurrentNodeIndex(glb_Tesei.getLastNodeIndex()+1)
					glb_Tesei.increaseLastNodeIndex()
					if LinesDifferent(glb_Tesei.getStartLineNum()+glb_Tesei.getCurrentNodeIndex()) == true then
						glb_FoundKeysAndValuesTable = nil 
						glb_ConvertedKeysAndValuesTable = {}
						GraphRootSearch()
					end
					-- glb_Tesei.setPreviousVisitedNode(glb_Tesei.getCurrentNodeIndex) -- Redundant
					DFS()
				end
			end
			
		else
			if glb_Tesei.getCurrentNodeIndex() ~= 0 then
				glb_NodeList[glb_Tesei.getCurrentNodeIndex()].toggleFlag_DownStraight()
			end
			do return end
		end	
	end
	
	local function goUpward()
		if glb_Tesei.getCurrentNodeIndex() ~= 0 then
			glb_Tesei.setPreviousVisitedNode(glb_Tesei.getCurrentNodeIndex())
			glb_Tesei.setCurrentNodeIndex(glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getParentNodeIndex())
		else
			do return end
		end
	end
	--=========
	
	-- Have to return all methods to make them public. Self table with attributes is still private.
	-- Tip: it is possible to right brackets '()' in the right side of eqaution and therefore call fucntions without brackets.
	-- But it breaks writing pattern of adding '()' in the end of any function.
	return 	{
			increaseLastNodeIndex = increaseLastNodeIndex,
			setCurrentNodeIndex = setCurrentNodeIndex,
			setPreviousVisitedNode = setPreviousVisitedNode,
			teleportTo = teleportTo,
			getCurrentNodeIndex = getCurrentNodeIndex,
			getLastNodeIndex = getLastNodeIndex,
			getStartLineNum = getStartLineNum,
			getPreviousVisitedNode = getPreviousVisitedNode,
			goRightAndDown = goRightAndDown,
			goDownStraight = goDownStraight,
			goUpward = goUpward
			}
end



-- Node object with its attributes and (hook to) methods.
function Node (ParentNodeIndex, counter_RightAndDown)
-- Table of attributes.
	local self =	{
					flag_RightAndDown 	= 0, 
					flag_DownStraight 	= 0,
					NodeIndex			= glb_Tesei.getLastNodeIndex()+1, -- it's also current line index / Could use triangle assymetrical matrice to index nodes. But it's redundant.
					ParentNodeIndex		= ParentNodeIndex,
					StrLine 			= getLine(glb_Tesei.getLastNodeIndex()+1+glb_Tesei.getStartLineNum()),
					counter_RightAndDown= counter_RightAndDown
					}
	
	-- A try to create visitor pattern
	--======
	-- local function self.accept(Node.toggleFlag_RightAndDown)
		-- return 
	-- end
	
	-- local function self.accept...
		-- return 
	-- end
	--===== 
	
	-- These methods should be in the outside interface (Node.toggle)
	--=========
 	local function toggleFlag_RightAndDown()
		self.flag_RightAndDown = 1
	end
	
	local function toggleFlag_DownStraight()
		self.flag_DownStraight = 1
	end
	--=========
		
	-- These methods should be in the outside interface (Node.get or getter)
	--=========
	local function getStrLine()
		return self.StrLine
	end
	
	local function getParentNodeIndex()
		return self.ParentNodeIndex
	end
	
	local function getFlag_RightAndDown()
		return self.flag_RightAndDown
	end
	
	local function getFlag_DownStraight()
		return self.flag_DownStraight
	end
	
	local function getCounter_RightAndDown()
		return self.counter_RightAndDown
	end
	--=========

	-- Have to return all methods to make them public. Self table with attributes is still private.
	-- Tip: it is possible to right brackets '()' in the right side of eqaution and therefore call fucntions without brackets.
	-- But it breaks writing pattern of adding '()' in the end of any function.

	return 	{
			toggleFlag_RightAndDown = toggleFlag_RightAndDown,
			toggleFlag_DownStraight = toggleFlag_DownStraight,
			getStrLine = getStrLine,
			getParentNodeIndex = getParentNodeIndex,
			getFlag_RightAndDown = getFlag_RightAndDown,
			getFlag_DownStraight = getFlag_DownStraight,
			getCounter_RightAndDown = getCounter_RightAndDown
			}
			
end



-- Helpers
--====================================
-- Helper to check next step.
function checkRightAndDown()
	if getLine(glb_Tesei.getLastNodeIndex()+1 + glb_Tesei.getStartLineNum()) == nil then -- Checks if the document has ended.
		return false
	else
		local indent = glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getCounter_RightAndDown()*2
		if string.find(getLine(glb_Tesei.getLastNodeIndex()+1 + glb_Tesei.getStartLineNum()), "  ", indent+1) ~= nil then -- in case when the very first node has counter = 1
			return true
		else
			return false
		end
	end
end

-- Helper to check next step.
function checkDownStraight()
	if getLine(glb_Tesei.getLastNodeIndex()+1 + glb_Tesei.getStartLineNum()) == nil then -- Checks if the document has ended.
		return false
	else
		local indent = glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getCounter_RightAndDown()*2
		if string.find(getLine(glb_Tesei.getLastNodeIndex()+1 + glb_Tesei.getStartLineNum()), "  ", indent+1) == nil -- in case when the very first node has counter = 1
			and
			string.find(getLine(glb_Tesei.getLastNodeIndex()+1 + glb_Tesei.getStartLineNum()), "  ", indent-1) ~= nil then
			return true
		else
			return false
		end
	end
end

-- Helper to get line
function getLine(LineNum)
	return glb_TextFileTableMod[LineNum]
end

-- Helper to compare lines
-- gets lines with same lineNum from two documents.
function LinesDifferent(LineNum)
	if glb_TextFileTableVanilla[LineNum] ~= glb_TextFileTableMod[LineNum] then
		return true
	else
		return false
	end
end

-- Helper to extract Values and Keys from the line
function ExtractNameAndValueFromLine(LineNum)
	local Start_pos1, End_pos1, Output_string1, Start_pos2, End_pos2, Output_string2 
	Start_pos1 = string.find(getLine(LineNum), "name=")
	if Start_pos1 ~= nil then
		End_pos1 = string.find(getLine(LineNum), '"', Start_pos1+6)
		Output_string1 = string.sub(getLine(LineNum), Start_pos1+5, End_pos1)
		Start_pos2 = string.find(getLine(LineNum), "value=", End_pos1)
		if Start_pos2 == nil then
			return Output_string1
		else
		End_pos2 = string.find(getLine(LineNum), '"', Start_pos2+7)
		Output_string2 = string.sub(getLine(LineNum), Start_pos2+6, End_pos2)
		local Output_string1_AND_Output_string2 = {}
		table.insert(Output_string1_AND_Output_string2, Output_string1)
		table.insert(Output_string1_AND_Output_string2, Output_string2)
			return Output_string1_AND_Output_string2
		end
	else
		Start_pos2 = string.find(getLine(LineNum), "value=", End_pos1)
		if Start_pos2 == nil then
			return
		else
			End_pos2 = string.find(getLine(LineNum), '"', Start_pos2+7)
			Output_string2 = string.sub(getLine(LinseNum), Start_pos2+6, End_pos2)
			return Output_string2
		end
	end
end

-- Helper to use ExtractNameAndValueFromLine with table.insert method.
function TableInsertAndWordExtractor(TableWhereToInsert, IndexWhereToInsert, LineNum)
	local ExtractedValues = ExtractNameAndValueFromLine(LineNum)
	if type(ExtractedValues) ~= table then
		table.insert(TableWhereToInsert, IndexWhereToInsert, ExtractedValues)
	else
		for i = 1, #ExtractedValues do
			table.insert(TableWhereToInsert, IndexWhereToInsert, ExtractedValues[i])
		end
	end
end
--====================================




-- Walker initialization (should be done every algorithm launch!)
--====================================
-- local glb_Tesei = Walker(StartLineNum) -- or needs global? Yes, needs global.
-- ====================================

-- Environment initialization (should be done every algorithm launch!)
--====================================
-- local glb_NodeList = {} -- or needs global? Yes, needs global.
--====================================



-- DFS
-- Was implemented in a memory greedy way. But mathematically beatiful.
function DFS()
	glb_Tesei.goRightAndDown()
	glb_Tesei.goDownStraight()
	glb_Tesei.goUpward()
end





-- GraphRootSearch algorithm
-- ==================================================================================
-- During Graph Root Search flag_DownStraight is used as the turning measure.
-- If flag_DownStraight=1, then walker have come from DownStraight Node. If flag_DownStraight=0, then walker have come from RightAndDown Node.
-- If flag_DownStraight=0, then we always should extract name and/or value from the current node. Otherwise nothing.


-- Initialization (should be done every algorithm launch!)
--====================================
-- glb_FoundKeysAndValuesTable = {} -- Global! Last value = the value to change in mod.
-- glb_ConvertedKeysAndValuesTable = {} -- Global! Duct tape
--====================================

function GraphRootSearch()
	glb_Tesei.goUpward()
	if glb_FoundKeysAndValuesTable == nil then
		glb_FoundKeysAndValuesTable = {}
		TableInsertAndWordExtractor(glb_FoundKeysAndValuesTable, 1, glb_Tesei.getStartLineNum() + glb_Tesei.getPreviousVisitedNode())
		if glb_Tesei.getCurrentNodeIndex() ~= 0 then -- To stop algorithm when it gets to root. Prevents calling table in glb_NodeList with index 0. Needed to work properly.
			if glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getFlag_DownStraight() == 0 then
				TableInsertAndWordExtractor(glb_FoundKeysAndValuesTable, 1, glb_Tesei.getStartLineNum() + glb_Tesei.getCurrentNodeIndex())
			end
		end
	elseif glb_Tesei.getCurrentNodeIndex() ~= 0 then -- To stop algorithm when it gets to root. Prevents calling table in glb_NodeList with index 0. Needed to work properly.
		if glb_NodeList[glb_Tesei.getCurrentNodeIndex()].getFlag_DownStraight() == 0 then
			TableInsertAndWordExtractor(glb_FoundKeysAndValuesTable, 1, glb_Tesei.getStartLineNum() + glb_Tesei.getCurrentNodeIndex())
		end
	end
	
	if	glb_Tesei.getCurrentNodeIndex() ~= 0 then
		GraphRootSearch()
	else
		TableConvertationToPKW(glb_FoundKeysAndValuesTable) -- Duct tape
		writeInNewScript_BODY_1(glb_ConvertedKeysAndValuesTable) -- Writing to new script here
		writeInNewScript_BODY_2(glb_ConvertedKeysAndValuesTable) -- And here
		glb_Tesei.teleportTo(glb_Tesei.getLastNodeIndex())
	end
end

-- Helper
-- Table convertation to format that PRECEDING_KEY_WORDS can understand.
function TableConvertationToPKW(glb_FoundKeysAndValuesTable) -- Duct tape
	for i = 1, #glb_FoundKeysAndValuesTable do
		local row_1, row_2 = table.unpack(glb_FoundKeysAndValuesTable[i])
		if row_1 and row_2 ~= nil then
			table.insert(glb_ConvertedKeysAndValuesTable, row_1)
			table.insert(glb_ConvertedKeysAndValuesTable, row_2)
		else
			table.insert(glb_ConvertedKeysAndValuesTable, glb_FoundKeysAndValuesTable[i])
		end
	end
end

-- added at version 1.1 for further improvements.
-- Buffer object to implement additional features.
function buffer_GRS
	local self = 	{
					SavedFoundKeysAndValuesTable = glb_FoundKeysAndValuesTable
					SavedConvertedKeysAndValuesTable = glb_ConvertedKeysAndValuesTable
					}

	local function setSavedFoundKeysAndValuesTable(NewValue)
		self.SavedFoundKeysAndValuesTable = NewValue
	end
	
	local function setSavedConvertedKeysAndValuesTable(NewValue)
		self.SavedConvertedKeysAndValuesTable = NewValue
	end


	local function getSavedFoundKeysAndValuesTable()
		return self.SavedFoundKeysAndValuesTable
	end

	local function getSavedConvertedKeysAndValuesTable()
		return self.SavedConvertedKeysAndValuesTable
	end

	
	return 	{
			setSavedFoundKeysAndValuesTable = setSavedFoundKeysAndValuesTable,
			setSavedConvertedKeysAndValuesTable = setSavedConvertedKeysAndValuesTable,
			getSavedFoundKeysAndValuesTable = getSavedFoundKeysAndValuesTable,
			getSavedConvertedKeysAndValuesTable = getSavedConvertedKeysAndValuesTable
			}
end
-- ==================================================================================
-- ==================================================================================


-- Write to new script algorithms
-- ==================================================================================
function writeInNewScript_BODY_1(glb_ConvertedKeysAndValuesTable)
	writeToFile(MOD_AUTOSCRIPT_BODY_1, Modified_EXML_name_cut)
	-- Additional condition for name of the key in name_and_value pair.
	-- Better to add it here because sometimes there are properties with only key or only value lines.
	-- And much more better to make additional object that stores attributes of ExtractNameAndValueFromLine and glb_FoundKeysAndValuesTable.
	--====================================
	local Start_pos_name, Start_pos_value 
	Start_pos_name = string.find(getLine(glb_Tesei.getStartLineNum() + glb_Tesei.getLastNodeIndex()), "name=")
	Start_pos_value = string.find(getLine(glb_Tesei.getStartLineNum() + glb_Tesei.getLastNodeIndex()), "value=")
	if Start_pos_name ~= nil and Start_pos_value ~= nil then
		for i = 1, #glb_ConvertedKeysAndValuesTable-2 do
			writeToFileCSV(glb_ConvertedKeysAndValuesTable[i], Modified_EXML_name_cut)
		end		
	else
	--====================================
		for i = 1, #glb_ConvertedKeysAndValuesTable-1 do
			writeToFileCSV(glb_ConvertedKeysAndValuesTable[i], Modified_EXML_name_cut)
		end
	end
	writeToFile(MOD_AUTOSCRIPT_BODY_1_CLOSURE, Modified_EXML_name_cut)
end

function writeInNewScript_BODY_2(glb_ConvertedKeysAndValuesTable)
	writeToFile(MOD_AUTOSCRIPT_BODY_2, Modified_EXML_name_cut)
	local NameValue = glb_ConvertedKeysAndValuesTable[#glb_ConvertedKeysAndValuesTable]
	-- Additional condition for name of the key in name_and_value pair.
	-- Better to add it here because sometimes there are properties with only key or only value lines.
	-- And much more better to make additional object that stores attributes of ExtractNameAndValueFromLine and glb_FoundKeysAndValuesTable.
	--====================================
	local Start_pos_name, Start_pos_value, End_pos_name, Output_string_name 
	Start_pos_name = string.find(getLine(glb_Tesei.getStartLineNum() + glb_Tesei.getLastNodeIndex()), "name=")
	Start_pos_value = string.find(getLine(glb_Tesei.getStartLineNum() + glb_Tesei.getLastNodeIndex()), "value=")
	if Start_pos_name ~= nil and Start_pos_value ~= nil then
		End_pos_name = string.find(getLine(glb_Tesei.getStartLineNum() + glb_Tesei.getLastNodeIndex()), '"', Start_pos_name+6)
		Output_string_name = string.sub(getLine(glb_Tesei.getStartLineNum() + glb_Tesei.getLastNodeIndex()), Start_pos_name+5, End_pos_name)
		writeToFileCSV(Output_string_name, Modified_EXML_name_cut)
	end
	--====================================
	writeToFileCSV(NameValue, Modified_EXML_name_cut)
	writeToFile(MOD_AUTOSCRIPT_BODY_2_CLOSURE, Modified_EXML_name_cut)
end
-- ==================================================================================



-- OUTPUT
--==================================================================================
CreateNewScript(Path .. Original_EXML_name, Path .. Modified_EXML_name) -- Launches this script.


print("The script of the modification is created as " .. Modified_EXML_name_cut .. "_AUTOSCRIPT.lua")
--==================================================================================
