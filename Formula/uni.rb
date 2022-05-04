class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.5.0.tar.gz"
  sha256 "27833125a4097e15ec6dbce33e2798a1689a4674c0d0509c0dc1039204aa1d80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cb783308d060cc8844fbdb27187ec853a1b4f3333def5483f329601af567f07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7117ab22880a486aaf1d933350ce6dbab7e030eceaf99a73952824877ed0601"
    sha256 cellar: :any_skip_relocation, monterey:       "0bb57b769a286599155766fb20c9fd923dcabaf2e0829ff473755d09b13226cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef54494e9c07aba6f8005fe34b9012fffb59d5cfa78e87b05cff0839cbede28a"
    sha256 cellar: :any_skip_relocation, catalina:       "950286c4f9e202ea7ec3cdfa3f02d4ea07ce4840506b53d933962b876d8bdc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16dc6e74f5960d8b00e0feedd868c812219080bddbf2e8aec510b68c90c2462"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
