class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R58.tgz"
  sha256 "608beb7b71870b23309ba1da8ca828da0e4540f2b9bd981eb39e04f8b7fc678c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ff89051970128cae9f0bb12e1934a52f6d51b6ab77f02b601ff4b708ee40e9a" => :catalina
    sha256 "0028f1d8028129a398937bed7fb3b2f7608932386d116d1b05527ff266c3470c" => :mojave
    sha256 "d666938f31f5c9e5a0dd4b5f0e823ca7d5f2015cc447284ff0204cdc874d70e4" => :high_sierra
    sha256 "1fbdae63a63116e3a321b71d632214ea2419d404db8939f7cb3471a2de35c761" => :sierra
  end

  def install
    system "sh", "./Build.sh", "-r"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
