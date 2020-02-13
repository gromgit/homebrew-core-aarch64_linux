class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20200206.963bc9d.tar.gz"
  version "20200206"
  sha256 "30f115f26d0a19dbce7f1ac3c7395ea8e584cb5e2a154ede767ebe16d5602222"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae7ab975a5c722805424eccc1648a51d14fc93f337cfe0b2b7cda71987b4c51c" => :catalina
    sha256 "f5199e0d872e1070f326335fb6db3e24292fa58dcaadfc73ace759eb1de032b6" => :mojave
    sha256 "3ca66bbd2834a4eb11bcc6d60baac58d1cecbb56d979afd000abb2c9a1d5944a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "halibut" => :build

  def install
    system "./mkauto.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_predicate testpath/"agedu.dat", :exist?
  end
end
