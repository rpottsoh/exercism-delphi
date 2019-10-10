unit uWordCount;

interface
uses
  System.Generics.Collections;

type
  IWordCount = interface
    ['{955DF34E-254D-44E1-B4F3-91F0DCF8B764}']
    function countWords: TDictionary<string, integer>;
  end;

function WordCount(aWords: string): IWordCount;

implementation

uses
  Character, SysUtils, RegularExpressions;

type
  TWordCount = class(TInterfacedObject, IWordCount)
  private
    FWords: string;
  public
    constructor Create(aWords: string);
    function countWords: TDictionary<string, integer>;
  end;

function WordCount(aWords: string): IWordCount;
begin
  result := TWordCount.Create(aWords);
end;

constructor TWordCount.Create(aWords: string);
begin
  inherited Create;
  FWords := aWords;
end;

function TWordCount.countWords: TDictionary<string, integer>;

  function TryCleanWord(const aWord: string; out CleanWord: string): boolean;
  begin
    CleanWord := aWord;
    if CleanWord.Trim.IsEmpty then
      exit(False);

    var TargetChar := CleanWord.Chars[0];

    if not TargetChar.IsLetterOrDigit and CleanWord.EndsWith(TargetChar) then
    begin
      CleanWord := CleanWord.Remove(0, 1);
      CleanWord := CleanWord.Remove(length(CleanWord) - 1);
    end;

    while not CleanWord[length(CleanWord)].IsLetterOrDigit and not CleanWord.IsEmpty do
      CleanWord := CleanWord.Remove(length(CleanWord) - 1);
    Result := not CleanWord.IsEmpty;
  end;

begin
  Result := TDictionary<string, integer>.Create;

  // convert to lowercase and trim spaces
  FWords := FWords.ToLowerInvariant.Trim;
  // replace all separators with spaces
  FWords := TRegEx.Replace(FWords, '(,|\\n|:)', ' ', [roNone]); //
  // get rid of extra characters
  FWords := TRegEx.Replace(FWords, '[^0-9a-z '']', '', [roNone]);
  // delete extra spaces
  FWords := TRegEx.Replace(FWords, '\s+', ' ', [roNone]);
  FWords := FWords.Trim;
  // replace all separators with spaces
  FWords := TRegEx.Replace(FWords, '(,|\\n|:)', ' ', [roNone]); //

  for var aWord in FWords.Split([' ']) do
  begin
    var CleanedWord: string;
    if TryCleanWord(aWord, CleanedWord) then
    begin
      if (not result.ContainsKey(CleanedWord)) then
        result.Add(CleanedWord, 0);
      result.Items[CleanedWord] := result.Items[CleanedWord] + 1;
    end;
  end;

end;

end.

