class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://gothenburgbitfactory.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.2.0.tar.gz"
  sha256 "6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/taskshell.git", branch: "1.3.0"

  # We check the upstream Git repository tags because the first-party download
  # page doesn't list tasksh releases.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "8b555506f7b5fea57888cdc777ecc3da950070596ea9d7fbe72a3f26180a0a87" => :big_sur
    sha256 "d5e252e9a4e1c0d2ecc8ed4fe9c1ec57a86c8b1b3102584903a5fe473a01a714" => :arm64_big_sur
    sha256 "e0963f51916b59d6f635a3c82a48a7ae7db0dfaa6699fedf6678a91734e0ea63" => :catalina
    sha256 "fbebc33442701a951a6a49c749be983cf7b7cd26134ac55d480a819304327286" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "task"

  on_linux do
    depends_on "readline"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/tasksh", "--version"
    (testpath/".taskrc").write "data.location=#{testpath}/.task\n"
    assert_match "Created task 1.", pipe_output("#{bin}/tasksh", "add Test Task", 0)
  end
end
