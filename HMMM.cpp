#include <cmath>
#include <cstdio>
#include <vector>
#include <iostream>
#include <algorithm>
#include <map>
#include <unordered_map>
#include <fstream>
#include <sstream>
#include <regex>
using namespace std;

map<string, string> opCodesTwo, opCodesOne, opCodesBr, opCodesSpecial, labels, functions;
map<string, int> variables;
vector<string> varVector;
vector<string> program;
vector<string> memory(2000, "0000000000000000");
vector<string> jmpVector;
std::string TrimLeft(const std::string &str)
{
    auto pos = str.find_first_not_of(' ');
    return str.substr(pos != std::string::npos ? pos : 0);
}
string stringToBinary(int s, int size)
{
    string binary = "";
    while (s)
    {
        if (s & 1)
            binary = '1' + binary;
        else
            binary = '0' + binary;
        s /= 2;
    }
    while (binary.length() != size)
        binary = '0' + binary;
    return binary;
}
string getRegAddMode(string s, int &count)
{
    int index = 7;
    int address = index;
    int indirect = 0;
    if (s[0] == '@')
    {
        indirect |= 8;
        s = s.substr(1);
    }
    if (s[0] == '#')
    {
        count++;
        address |= 16;
        s = s.substr(1);
        int number = stoi(s);
        if (number < 0)
        {
            string binary = stringToBinary(number * -1, 15);
            int index = 14;
            while (index >= 0)
            {
                if (binary[index] == '1')
                    break;
                index--;
            }
            index--;
            while (index >= 0)
            {
                if (binary[index] == '1')
                    binary[index] = '0';
                else
                    binary[index] = '1';
                index--;
            }
            memory[count] = '1' + binary;
        }
        else
            memory[count] = stringToBinary(number, 16);
    }
    else if (variables[s] != 0)
    {
        address |= 48;
        count++;
        memory[count] = s;
    }
    else
    {
        index = s.find('R');
        address = s[index + 1] - '0';
        if (s[4] == '+')
            address |= 16;
        if (s[0] == '-' && s[1] == '(')
            address |= 32;
        if (s[0] >= '0' && s[0] <= '9' || (s[1] >= '0' && s[1] <= '9' && s[0] == '-'))
        {
            address |= 48;
            count++;
            if (s[0] >= '0' && s[0] <= '9')
            {
                string indexed_val = s.substr(0, s.find('('));
                memory[count] = stringToBinary(stoi(indexed_val), 16);
            }
            else
            {
                string indexed_val = s.substr(1, s.find('('));
                string binary = stringToBinary(stoi(indexed_val), 15);
                int ind = 14;
                while (ind >= 0)
                {
                    if (binary[ind] == '1')
                        break;
                    ind--;
                }
                ind--;
                while (ind >= 0)
                {
                    if (binary[ind] == '1')
                        binary[ind] = '0';
                    else
                        binary[ind] = '1';
                    ind--;
                }
                memory[count] = '1' + binary;
            }
        }
    }
    address |= indirect;

    return stringToBinary(address, 6);
}

pair<string, int> splitInstruction(string line, int &numberOfWords)
{
    line = TrimLeft(line);
    string src = "";
    string dst = "";
    string IR = "";
    pair<string, int> out("", -1);
    string op = line.substr(0, line.find(' '));
    if (op[op.length() - 1] == ';')
        op = op.substr(0, line.find(';'));
    if (op.length() == 0 || line[0] == ';' || op == "DEFINE")
        return out;
    string temp = TrimLeft(line.substr(op.length()));
    if (temp[0] == ':')
        op.push_back(':');
    if (op[op.length() - 1] == ':')
    {
        op.erase(op.length() - 1);
        labels[op] = to_string(numberOfWords + 1);
        line = TrimLeft(line.substr(line.find(':')));
        line.erase(0);
        op = line.substr(0, line.find(' '));
    }
    else if (opCodesTwo[op] == "" && opCodesOne[op] == "" && opCodesBr[op] == "" && opCodesSpecial[op] == "")
    {
        functions[op] = to_string(numberOfWords + 1);
        line = TrimLeft(line.substr(op.length()));
        op = line.substr(0, line.find(' '));
    }
    if (op.length() == 0 || line[0] == ';' || op == "DEFINE")
        return out;
    numberOfWords++;
    out.second = numberOfWords;
    if (opCodesTwo[op] != "")
    {
        line = TrimLeft(line.substr(op.length()));
        src = line.substr(0, line.find(','));
        string srcMode = getRegAddMode(src, numberOfWords);
        line = TrimLeft(line.substr(line.find(',') + 1));
        dst = line.substr(0, line.find(' '));
        string dstMode = getRegAddMode(dst, numberOfWords);
        IR = opCodesTwo[op] + srcMode + dstMode;
    }
    else if (opCodesOne[op] != "")
    {
        line = TrimLeft(line.substr(op.length()));
        src = line.substr(0, line.find(' '));
        string srcMode = getRegAddMode(src, numberOfWords);
        IR = opCodesOne[op] + "00" + srcMode;
    }
    else if (opCodesBr[op] != "")
    {
        line = TrimLeft(line.substr(op.length()));
        src = line.substr(0, line.find(' '));
        IR = opCodesBr[op];
        if (labels[src] != "")
        {
            string binary = stringToBinary((stoi(labels[src]) - (numberOfWords + 1)) * -1, 7);
            int index = 6;
            while (index >= 0)
            {
                if (binary[index] == '1')
                    break;
                index--;
            }
            index--;
            while (index >= 0)
            {
                if (binary[index] == '1')
                    binary[index] = '0';
                else
                    binary[index] = '1';
                index--;
            }
            IR += '1' + binary;
        }
        else
            jmpVector.push_back(src);
    }
    else if (opCodesSpecial[op] != "")
    {
        if (op == "JSR")
        {
            numberOfWords++;
            line = TrimLeft(line.substr(op.length()));
            src = line.substr(0, line.find(' '));
            memory[numberOfWords] = src;
        }
        IR = opCodesSpecial[op] + "00000110";
    }
    out.first = IR;
    return out;
}
bool fillVar(string line)
{
    line = TrimLeft(line);
    if (line.length() == 0 || line[0] == ';')
        return 1;
    if (line.find("DEFINE") == string::npos)
        return 0;
    line = TrimLeft(line.substr(6));
    string name = line.substr(0, line.find(' '));
    line = line.substr(line.find(' '));
    line = TrimLeft(line);
    string val = line.substr(0, line.find(' '));
    variables[name] = stoi(val);
    varVector.push_back(name);
    return 1;
}

int main(int argc, char **argv)
{
    string inputFileName = "E:/Projects/arc-project/assembler/aa.asm";

    // 2 OPERAND OP CODES
    opCodesTwo["MOV"] = "0001";
    opCodesTwo["ADD"] = "0010";
    opCodesTwo["ADC"] = "0011";
    opCodesTwo["SUB"] = "0100";
    opCodesTwo["SBC"] = "0101";
    opCodesTwo["AND"] = "0110";
    opCodesTwo["OR"] = "0111";
    opCodesTwo["XOR"] = "1000";
    opCodesTwo["CMP"] = "1001";

    // 1 OPERAND OP CODES
    opCodesOne["INC"] = "10110001";
    opCodesOne["DEC"] = "10110010";
    opCodesOne["CLR"] = "10110011";
    opCodesOne["INV"] = "10110100";
    opCodesOne["LSR"] = "10110101";
    opCodesOne["ROR"] = "10110110";
    opCodesOne["ASR"] = "10110111";
    opCodesOne["LSL"] = "10111000";
    opCodesOne["ROL"] = "10111001";
    // opCodesOne["JSR"] = "11110011"; /* need to be handled*/

    // BRANCH OP CODES
    opCodesBr["BR"] = "11010001";
    opCodesBr["BEQ"] = "11010010";
    opCodesBr["BNE"] = "11010011";
    opCodesBr["BLO"] = "11010100";
    opCodesBr["BLS"] = "11010101";
    opCodesBr["BHI"] = "11010110";
    opCodesBr["BHS"] = "11010111";

    //Special Operations
    opCodesSpecial["HLT"] = "11110001";
    opCodesSpecial["NOP"] = "11110010";
    opCodesSpecial["JSR"] = "11110011";
    opCodesSpecial["RTS"] = "11110100";
    opCodesSpecial["IRET"] = "11110101";

    string line;
    ifstream input_file(inputFileName);
    if (input_file.is_open())
    {
        while (getline(input_file, line))
        {
            int index = 0;
            line = TrimLeft(line);
            for (auto c : line)
            {
                line[index] = toupper(c);
                index++;
            }
            program.push_back(line);
        }
        input_file.close();
    }
    for (int i = program.size() - 1; i >= 0; i--)
        if (!fillVar(program[i]))
            break;
    int numberOfWords = -1;
    for (int i = 0; i < program.size(); i++)
    {
        auto p = splitInstruction(program[i], numberOfWords);
        if (p.second != -1)
            memory[p.second] = p.first;
    }
    for (int i = varVector.size() - 1; i >= 0; i--)
    {
        numberOfWords++;
        memory[numberOfWords] = stringToBinary(variables[varVector[i]], 16);
        variables[varVector[i]] = numberOfWords;
    }
    for (int i = 0; i <= numberOfWords; i++)
    {
        if (variables[memory[i]] != 0)
        {
            memory[i] = stringToBinary(variables[memory[i]] - (i + 1), 16);
        }
    }

    for (int i = 0; i <= numberOfWords; i++)
    {
        if (functions[memory[i]] != "")
        {
            memory[i] = stringToBinary(stoi(functions[memory[i]]), 16);
        }
    }
    int index = 0;
    for (int i = 0; i <= numberOfWords; i++)
    {
        if (memory[i].length() == 8)
        {
            int offset = stoi(labels[jmpVector[index]]) - (i + 1);
            string offset_str = stringToBinary(offset, 8);
            memory[i] += offset_str;
            index++;
        }
    }

    ofstream outputFile("memory.mem");
    if (outputFile.is_open())
    {
        outputFile << "// instance=/integration/ramMemory/ram\n"
                   << "// format=mti addressradix=d dataradix=s version=2.0 wordsperline=1\n";
        for (int i = 0; i < memory.size(); i++)
            outputFile
                << i << ": " << memory[i] << "\n";
        outputFile.close();
    }
    return 0;
}
