class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.05.tar.gz"
  sha256 "61ed17d86bde93fa7268d57118a2fbef739626f0b823a1799c4b11420cd66ec1"
  license "GPL-2.0-only"
  head "https://dianne.skoll.ca/projects/remind/git/Remind.git"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6c479910c960f05d2a3a3b2f12323628d41f03553de2584696f1a95ffc7ad6ee" => :big_sur
    sha256 "01501198dbbfcc40670c97d38cff99ccaf00644e259a01b33ac57d44c4446267" => :arm64_big_sur
    sha256 "39f0993b9ceeeb6e96e050f5959e1bf58c9f59657e0174d7bfec73a036d032b0" => :catalina
    sha256 "de6b40ee75e1ad87d9a99dafe0c0d58e03c179d7327cb60e485456352dc9338c" => :mojave
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
