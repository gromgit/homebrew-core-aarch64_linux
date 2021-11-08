class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.27.tar.gz"
  sha256 "a69913029933fccc187ad1243bf57a7e799ce06b8f3d813174af3c8d78054b14"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4452457049b3e132a8fb139acf030bc7a48bb56a57273b10ebb072c66fe4350"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa79fc15a78234ae5481933d56056c707415e5472ae722e21c06f050e244912c"
    sha256 cellar: :any_skip_relocation, monterey:       "07f09f901dfe32aab1ab8736590907cec295b5fdc82693be12dda59e547e642d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f402c687a0dcf887164ec9ac26f7cf8b415398de36fd2f350cab862c3df2ef77"
    sha256 cellar: :any_skip_relocation, catalina:       "1605b9ab02ba26aaa0ed09b09e95df5c4294c89bcfca2b1af90caae0c13d30fe"
    sha256 cellar: :any_skip_relocation, mojave:         "e9c44f3c065dbb13fc50e85e72f7957ca89c25bc29f492861d7e227032a395ee"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "gperf" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
