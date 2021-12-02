class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.11.1.tar.gz"
  sha256 "2d442f32e3a7beac3d41ef73be96c1e7a8d349c63abbe666adf3038857a7b26d"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c865ccdb37587aabc08e4447b0aff8f69ccac03e649e2a7fd4ce64d8a5177a26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffcba473b6fb14dcb9a2f898b34440d847c71fc3f09dcbbdd43ede863b79e430"
    sha256 cellar: :any_skip_relocation, monterey:       "8dd4309ece8f59240796b949dc9dbd1c70c85b4e43bd81e0d24346ebed0cf568"
    sha256 cellar: :any_skip_relocation, big_sur:        "381e56427ac874bd22d20cfc10bb19b12fe5b3249191953465c1087bb96d478b"
    sha256 cellar: :any_skip_relocation, catalina:       "0fbdbd762d0b588f005e85ac9664d9fb6ea857936ce3ee048b1bf21ca0ac4802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2981491cfa1398e77e78e1e609bc4606d73616c6a24843688ad61fae34b9957"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
