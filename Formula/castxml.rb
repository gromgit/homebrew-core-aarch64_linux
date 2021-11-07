class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.4.tar.gz"
  sha256 "e7343edf262b291a9a3d702dbfa6d660e8ed81170454eab6af10a6dbf8c8141d"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e58197b33c7d3eba47163eee4dc75a7acabd1e08a14db13e4654962df9c4c3fb"
    sha256 cellar: :any,                 arm64_big_sur:  "d0e05d60c1a96f65e5a492a6532e60c7907386fee4f5cf961e183aba7c02d846"
    sha256 cellar: :any,                 monterey:       "da814bc8f6d43e55ea39cb79cc095cf1806d82645ec4bcfbffc612aabfb56fc6"
    sha256 cellar: :any,                 big_sur:        "8f6cf4bf0246dd2af8d297ea05a61d93687d1607084e8fb0e4c422b3f676889f"
    sha256 cellar: :any,                 catalina:       "180ea24e0b779c8003f0a76a9d9a2db7d2c32812ae9686bc47a14df208a326ec"
    sha256 cellar: :any,                 mojave:         "d334ea9ce46b1345b8bb79eb2f2f7f1d4d4f595f6d395a2fb4271eb985dd16e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e0d381ef2d6403f64f356b7227dbce4a6a93441bbe0982aa7d8adf9cab9339"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                             "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
