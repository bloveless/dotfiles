let
  bayer-brennon-work = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL7r4+xTYVZjNjbpGq1+rdUpVO8pyEhnMH3NctPTEDMF";
in
{
  "bayer-github-token.age".publicKeys = [ bayer-brennon-work ];
}
