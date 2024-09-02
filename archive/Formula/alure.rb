class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "https://kcat.tomasu.net/alure.html"
  url "https://kcat.tomasu.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"
  license "MIT"
  revision 1

  livecheck do
    url "https://kcat.tomasu.net/alure-releases/"
    regex(/href=.*?alure[._-]v?(\d+(?:\.\d+)+)(?:[._-]src)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/alure"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "20b107471600f85d9ef002c1574abcb3a8dc35856947e79358c318ee24c7f839"
  end


  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "openal-soft"
  end

  patch do
    on_high_sierra :or_newer do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/eed63e836e/alure/unistd.patch"
      sha256 "7852a7a365f518b12a1afd763a6a80ece88ac7aeea3c9023aa6c1fe46ac5a1ae"
    end
  end

  # Fix missing unistd include
  # Reported by email to author on 2017-08-25

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/alureplay 2>&1", 1)
    assert_match "Usage #{bin}/alureplay <soundfile>", output
  end
end
