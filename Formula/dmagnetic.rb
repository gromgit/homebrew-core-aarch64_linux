class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.33.tar.bz2"
  sha256 "4199966f214667c78c7133b8b0c93ff4b8c65c8dfdb2ff9487a0b3b1726af212"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dMagnetic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "885e8f3ef646dae1dace1b98aaece45f34cbe2620df6ec3bfce1a365389846c9"
    sha256 arm64_big_sur:  "71ba39c336103b2afbd4e56bc83757f1670f605fe9aaabe57ffefc4f8d81d062"
    sha256 monterey:       "0aa1ab87277e0f6906392207207b1201f4dc95f7d7c711f1ac804cf0e5a7ddd9"
    sha256 big_sur:        "c7ab46e3d6a4417e636f98ad4d57c710f5ff21be10bdbaea256f73a1c3882543"
    sha256 catalina:       "74a2565a3f522514d5fa43421d117c296294e8fc87b067bb5a9774e269106c81"
    sha256 x86_64_linux:   "2236c9dc5af99734e518c6c3245ce02f14fd5f8596897f7d4efe643e6ec085dd"
  end

  def install
    # Look for configuration and other data within the Homebrew prefix rather than the default paths
    inreplace "src/toplevel/dMagnetic_pathnames.h" do |s|
      s.gsub! "/etc/", "#{etc}/"
      s.gsub! "/usr/local/", "#{HOMEBREW_PREFIX}/"
    end

    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    args = %W[
      -vmode none
      -vcols 300
      -vrows 300
      -vecho -sres 1024x768
      -mag #{share}/games/dMagnetic/minitest.mag
      -gfx #{share}/games/dMagnetic/minitest.gfx
    ]
    command_output = pipe_output("#{bin}/dMagnetic #{args.join(" ")}", "Hello\n")
    assert_match(/^Virtual machine is running\..*\n> HELLO$/, command_output)
  end
end
