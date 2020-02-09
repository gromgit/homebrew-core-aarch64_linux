class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v0.18.3.tar.gz"
  sha256 "2e65f6c8757dd5107c4ac7032e3cc1bfec785cfec84e33b2d1b365a31c8ee17b"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :catalina
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :mojave
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :high_sierra
  end

  depends_on "fzf"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script(libexec/"navi")
  end

  test do
    assert_equal version, shell_output("#{bin}/navi --version")
  end
end
