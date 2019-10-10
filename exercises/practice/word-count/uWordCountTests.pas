unit uWordCountTests;

interface
uses
  System.Generics.Collections, DUnitX.TestFramework;

const
  CanonicalVersion = '1.4.0';

type

  [TestFixture]
  WordCountTests = class(TObject)
  private
    Expected,
    Actual: TDictionary<String, integer>;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
//    [Ignore('Comment the "[Ignore]" statement to run the test')]
    procedure Count_one_word;

    [Test]
    [Ignore]
    procedure Count_one_of_each_word;

    [Test]
    [Ignore]
    procedure Multiple_occurrences_of_a_word;

    [Test]
    [Ignore]
    procedure Handles_cramped_lists;

    [Test]
    [Ignore]
    procedure Handles_expanded_lists;

    [Test]
    [Ignore]
    procedure Ignore_punctuation;

    [Test]
    [Ignore]
    procedure Include_numbers;

    [Test]
    [Ignore]
    procedure Normalize_case;

    [Test]
    [Ignore]
    procedure With_apostrophes;

    [Test]
    [Ignore]
    procedure With_quotations;

    [Test]
    [Ignore]
    procedure Multiple_spaces_not_detected_as_a_word;

    [Test]
    [Ignore]
    procedure Alternating_word_separators_not_detected_as_a_word;

    [Test]
    [Ignore]
    procedure With_leading_apostrophes;
  end;

implementation

uses SysUtils, uWordCount;

type
  Assert = class(DUnitX.TestFramework.Assert)
    class procedure AreEqual(expected, actual: TDictionary<string, integer>); overload;
  end;


procedure WordCountTests.Alternating_word_separators_not_detected_as_a_word;
begin
  Expected.Add('one',1);
  Expected.Add('two',1);
  Expected.Add('three',1);

  Actual := WordCount(',\n,one,\n ,two \n ''three''').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Count_one_word;
begin
  Expected.Add('word',1);

  Actual := WordCount('word').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Count_one_of_each_word;
begin
  Expected.Add('one',1);
  Expected.Add('of',1);
  Expected.Add('each',1);

  Actual :=  WordCount('one of each').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Multiple_occurrences_of_a_word;
begin
  Expected.Add('one',1);
  Expected.Add('fish',4);
  Expected.Add('two',1);
  Expected.Add('red',1);
  Expected.Add('blue',1);

  Actual := WordCount('one fish two fish red fish blue fish').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Handles_cramped_lists;
begin
  Expected.Add('one',1);
  Expected.Add('two',1);
  Expected.Add('three',1);

  Actual := WordCount('one,two,three').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Handles_expanded_lists;
begin
  Expected.Add('one',1);
  Expected.Add('two',1);
  Expected.Add('three',1);

  Actual := WordCount('one,\ntwo,\nthree').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Ignore_punctuation;
begin
  Expected.Add('car',1);
  Expected.Add('carpet',1);
  Expected.Add('as',1);
  Expected.Add('java',1);
  Expected.Add('javascript',1);

  Actual := WordCount('car: carpet as java: javascript!!&@$%^&').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Include_numbers;
begin
  Expected.Add('testing',2);
  Expected.Add('1',1);
  Expected.Add('2',1);

  Actual := WordCount('testing, 1, 2 testing').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Normalize_case;
begin
  Expected.Add('go',3);
  Expected.Add('stop',2);

  Actual := WordCount('go Go GO Stop stop').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Setup;
begin
  Expected := TDictionary<String, integer>.Create;
end;

procedure WordCountTests.TearDown;
begin
  Expected.DisposeOf;
  Actual.DisposeOf;
end;

procedure WordCountTests.With_apostrophes;
begin
  Expected.Add('first',1);
  Expected.Add('don''t',2);
  Expected.Add('laugh',1);
  Expected.Add('then',1);
  Expected.Add('cry',1);

  Actual := WordCount('First: don''t laugh. Then: don''t cry.').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.With_leading_apostrophes;
begin
  Expected.Add('my',1);
  Expected.Add('country',1);
  Expected.Add('''tis',1);
  Expected.Add('of',1);
  Expected.Add('thee',1);

  Actual := WordCount('My country ''tis of thee').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.With_quotations;
begin
  Expected.Add('joe',1);
  Expected.Add('can''t',1);
  Expected.Add('tell',1);
  Expected.Add('between',1);
  Expected.Add('large',2);
  Expected.Add('and',1);

  Actual := WordCount('Joe can''t tell between ''large'' and large').countWords;

  Assert.AreEqual(Expected, Actual);
end;

procedure WordCountTests.Multiple_spaces_not_detected_as_a_word;
begin
  Expected.Add('multiple',1);
  Expected.Add('whitespaces',1);

  Actual := WordCount(' multiple   whitespaces').countWords;

  Assert.AreEqual(Expected, Actual);
end;

class procedure Assert.AreEqual(Expected, Actual: TDictionary<String, Integer>);
var
  expectedPair: TPair<string, Integer>;
begin
  Assert.AreEqual(Expected.Count, Actual.Count,
    '{Word counts should be equal}');
  for expectedPair in Expected do
  begin
    Assert.IsTrue(Actual.ContainsKey(expectedPair.Key),
      format('Actual doesn''t contain Expected "%s"',[expectedPair.Key]));
    Assert.AreEqual(expectedPair.Value, Actual[expectedPair.Key],
      format('{Expected %s: %d; Actual %s: %d}',
        [expectedPair.Key,
         expectedPair.Value,
         expectedPair.Key,
         Actual[expectedPair.Key]]));
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(WordCountTests);
end.
