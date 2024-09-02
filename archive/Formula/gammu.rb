class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.42.0.tar.xz"
  sha256 "d8f152314d7e4d3d643610d742845e0a016ce97c234ad4b1151574e1b09651ee"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  livecheck do
    url "https://wammu.eu/download/gammu/"
    regex(/href=.*?gammu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gammu"
    sha256 aarch64_linux: "564933bb2a47c6b093468df4bfe44c4ea1a74ebe678f4da96a4d10451a66c161"
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    # Disable opportunistic linking against Postgres
    inreplace "CMakeLists.txt", "macro_optional_find_package (Postgres)", ""
    system "cmake", "-S", ".", "-B", "build",
                    "-DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end
