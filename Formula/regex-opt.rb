class RegexOpt < Formula
  desc "Perl-compatible regular expression optimizer"
  homepage "https://bisqwit.iki.fi/source/regexopt.html"
  url "https://bisqwit.iki.fi/src/arch/regex-opt-1.2.4.tar.gz"
  sha256 "128c8ba9570b1fd8a6a660233de2f5a4022740bc5ee300300709c3894413883f"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?regex-opt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/regex-opt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5bea9e4c3e39701434a75817f92f074488ddc81916b2a49e3858eaf0fd2c4b9b"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "regex-opt"
  end

  test do
    output = shell_output("#{bin}/regex-opt foo...*..*bar")
    assert_equal "foo.{3,}bar", output
  end
end
