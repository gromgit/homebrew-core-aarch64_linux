class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.36.tar.gz"
  sha256 "18087d6e2661abc4c8946a3ed0996145b22631c686cac06e2a3600dad576d59b"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "853bc980be5d3c5993ec4c5eb23ad935419ad3826d44f1bb2512e10a3adcc6b2" => :catalina
    sha256 "f5dd3f29cf9a64a9824029677fd99b662c6ae7e3f84763e00daffa377bfd44c4" => :mojave
    sha256 "ca27eb8b65055eb7751c6a38db7302dfbcf20b174e1d19d305db155f75772b60" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
