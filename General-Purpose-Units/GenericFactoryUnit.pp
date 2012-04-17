unit GenericFactoryUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GenericStackUnit, GenericCollectionUnit;

type
  TFactorizable= interface
    procedure Reset;
  end;
  { TGenericFactoy }

  generic TGenericFactoy<T>= class (TObject)
  private
    type
      TStackOfT= specialize TGenericStack<T>;
      TCollectionOfT= specialize TGenericCollection<T>;

    var
      AvailableItems: TStackOfT;
      AllItems: TCollectionOfT;

  public
    constructor Create (InitialMember: Integer= 0);
    destructor Destroy; override;

    {
      Return an availabe member, if one exists, or create a new object of type T,
        otherwise.
    }
    function GetNewMemeber: T;
    {
    Returns the number of availabe members
    }
    function ReleaseMemeber (AMember: T): Integer;

  end;
implementation

{ TGenericFactoy }

constructor TGenericFactoy.Create (InitialMember: Integer);
var
  i: Integer;
  Obj: T;

begin
  inherited Create;

  AvailableItems:= TStackOfT.Create;
  AllItems:= TCollectionOfT.Create;
//  AllItems.Capacity:= InitialMember+ 1;

  for i:= 1 to InitialMember do
  begin
    Obj:= T.Create;
    AvailableItems.Push (Obj);
    AllItems.AddItem (Obj);

  end;

end;

destructor TGenericFactoy.Destroy;
begin
  AllItems.Free;
  AvailableItems.Free;

  inherited Destroy;
end;

function TGenericFactoy.GetNewMemeber: T;

begin
  if not AvailableItems.IsEmpty then
    Result:= AvailableItems.Pop
  else
  begin
    Result:= T.Create;

//    AvailableItems.Push (T.Create);
//    Result:= AvailableItems.Pop;

    AllItems.AddItem (Result);

  end;

end;

function TGenericFactoy.ReleaseMemeber (AMember: T): Integer;
begin
  AMember.Reset;
  AvailableItems.Push (AMember);

end;

end.

