program appsfv;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'pas\uPrincipal.pas' {fPrincipal},
  uLogin in 'pas\uLogin.pas' {fLogin},
  uSplash in 'pas\uSplash.pas' {fSplash};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfSplash, fSplash);
  Application.Run;
end.
