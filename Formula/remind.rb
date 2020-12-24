class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.03.tar.gz"
  sha256 "10f946fd5b5cd83e4ba435ca493d3ebff235a5808aef1f871010942e95ea8e02"
  license "GPL-2.0-only"
  head "https://dianne.skoll.ca/projects/remind/git/Remind.git"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fbeb40884bc1f988b217e094cecc2ff0b1700c2f8b050df71f5bf20468cdda35" => :big_sur
    sha256 "00fc0c53fa14558604577512f01da13ca4bef2315a10f13a212239708dd109ce" => :arm64_big_sur
    sha256 "430dee13826b27ec7fe83de7a7a48342c63f198c75d7db7081177065b6021d14" => :catalina
    sha256 "be51d268452bde2df71b4f9a13f3d1c60fd6680b55be7500b8336d8d224d1910" => :mojave
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
