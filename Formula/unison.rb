class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.2.tar.gz"
  sha256 "a2efcbeab651be6df69cc9b253011a07955ecb91fb407a219719451197849d5e"
  license "GPL-3.0"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  livecheck do
    url "https://github.com/bcpierce00/unison/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:v\d+)?)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "045499eab89d6b0d3faa898fe91c71bc7cba031c5a244c2f7367bc3825c958b5" => :catalina
    sha256 "58e3ccf3e3f0ac6b331b786fdb7bbe9f0e22babec094279f2c715bef256daacb" => :mojave
    sha256 "0cce7f269f0458a4ce1318fce5af58f9bcbfd29e314211fc8dedb6b4d8a7f1fb" => :high_sierra
  end

  depends_on "ocaml" => :build

  # Upstream fix for compatibility with OCaml 4.08 and later
  # https://github.com/bcpierce00/unison/pull/276
  patch do
    url "https://github.com/bcpierce00/unison/commit/23fa1292.patch?full_index=1"
    sha256 "25e3a4fc4460e40fcc61135b13effdc6ec71b8399af7d1f9d6399c7e96e07fbd"
  end

  # compatibility fix with ocaml 4.10
  patch do
    url "https://github.com/bcpierce00/unison/commit/acbce432.patch?full_index=1"
    sha256 "07e94b6a16b32f9aa46bb1b9a3592a70f37ecbd80bc5c4bd6b39736b5969f83f"
  end

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
