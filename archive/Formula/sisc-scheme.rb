class SiscScheme < Formula
  desc "Extensive Java based Scheme interpreter"
  homepage "http://sisc-scheme.org/"
  url "https://downloads.sourceforge.net/project/sisc/SISC%20Lite/1.16.6/sisc-lite-1.16.6.tar.gz"
  sha256 "7a2f1ee46915ef885282f6df65f481b734db12cfd97c22d17b6c00df3117eea8"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sisc-scheme"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c8a0282e8f1d96522f1bb5c53871f8782e2674ea30364c24cb2c2ccc7d7c434f"
  end

  def install
    libexec.install Dir["*"]
    (bin/"sisc").write <<~EOS
      #!/bin/sh
      SISC_HOME=#{libexec}
      exec #{libexec}/sisc "$@"
    EOS
  end
end
