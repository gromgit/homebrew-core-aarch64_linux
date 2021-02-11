class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.13.tar.gz"
  sha256 "8e8293bbda601d0cd1b971596cdab17d3d99648cc0dfa0d628af7f66d3cf593b"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd4f1dd41d6c37290b6805d0f7ff0aa72397d5899f4f1749c8d79614c3e4ea2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "882c3c298262ce107996b433bed0a749448fabe086c991d853d1877934967bfc"
    sha256 cellar: :any_skip_relocation, catalina:      "22ca42e8ccdaf7a8f6c3fdd7fee2e77a2bb80e8d19f9296bb7a4cb158b1c4404"
    sha256 cellar: :any_skip_relocation, mojave:        "6fa2b9f102762b190f1b6a205e32ef1d4236f920472f20cb4a4187fc5ec090d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
