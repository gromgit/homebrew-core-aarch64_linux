class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r18.tar.gz"
  sha256 "b9aba66ee8f0ca8229d4d3c0956fa7a7fd71a7e099e119d5609d29a1d9019344"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6044386633dc91ab445dbf477b18c2e6e5502a382036d6e87dd5cb9ff2d4f59e" => :big_sur
    sha256 "eb38a263925e44e832d9569d1a4216ae4f5196e34933e7080587986a1b70e155" => :arm64_big_sur
    sha256 "168e8bb96c49691e5dad111bcce04c4877e22a730fe12e41ae2f87fdca139fe9" => :catalina
    sha256 "bfd50575aa60082a49d4710a0dc414ff29e0f46093be5209e53253ba2aac15ca" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
