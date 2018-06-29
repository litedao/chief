{ stdenv, makeWrapper, lib, fetchFromGitHub, glibcLocales
, seth, curl, jshon, gnused, which, perl
}:

stdenv.mkDerivation rec {
  name = "chief-${version}";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [makeWrapper];
  buildPhase = "true";
  makeFlags = ["prefix=$(out)"];
  postInstall = let path = lib.makeBinPath [
    seth curl jshon gnused which perl
  ]; in ''
    wrapProgram "$out/bin/chief" --prefix PATH : "${path}" \
      ${if glibcLocales != null then
        "--set LOCALE_ARCHIVE \"${glibcLocales}\"/lib/locale/locale-archive"
        else ""}
  '';

  meta = with lib; {
    description = "Vote on ds-chief";
    homepage = https://github.com/makerdao/chief;
    license = licenses.gpl3;
    inherit version;
  };
}
