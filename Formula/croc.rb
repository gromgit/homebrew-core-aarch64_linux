class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.9.tar.gz"
  sha256 "0ef4359916e02fd7c754bda7093c924310729e002a06cfe015ea57b34b522cbf"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d94f1c1991f65b3afcdaedb86e43210dd112a58eb97049b70656ddeb494db167"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cf6972c9359fa34824e70aaeeaa006b48d79d94627bdd9f5607f4e2dd46fc15"
    sha256 cellar: :any_skip_relocation, catalina:      "94a1efeed361e54837b0bc7824ece468a10835d2ac8f18b8a45eeaac2a4f5a5a"
    sha256 cellar: :any_skip_relocation, mojave:        "411dc9e68dd9e5c755588a4a61f03e7311c4077b2fe8f9bdb4f7df2d38ac85ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
