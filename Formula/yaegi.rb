class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.14.0.tar.gz"
  sha256 "cd705e81229a0b316d3863d45d4c9263c393863632cdb3897365c4ec05e1a833"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fa7113b321fb312cc8510eea9893cfbfe14e2e69bb9133b05c2ddd55f9bc31a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea35cf51d0c5f4051583f124d4c8b4c6c575607427624bd2125ade2db235ad79"
    sha256 cellar: :any_skip_relocation, monterey:       "5e44c7df1dda158fecabd8a5882cb17e52fe356b595c13885d2c4ee430bfe1a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b54179391aa7a655bca5cc6dffc4e355db1e9c169a75f34bd4ad2195917e8d0"
    sha256 cellar: :any_skip_relocation, catalina:       "4384263208370e17c9be49e2a0d47a507360957a460194d4551e8b5e7e6922f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db2a8f21089e65c94c1822d3f1d4cbca69dbfbc3c3640ad774a487d4704358e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
