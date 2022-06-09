class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/1.4.2.tar.gz"
  sha256 "e85468dad3bf78c3fc32fc2ab53ef2d6bc28c3f9297410917af382a6d795574b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/td"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4ed8bfb78f24c6d4fe7a2d77338b5d1bc82911b7e3097f40d47bdac41ba906a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/".todos").write "[]\n"
    system "#{bin}/td", "a", "todo of test"
    todos = (testpath/".todos").read
    assert_match "todo of test", todos
    assert_match "pending", todos
  end
end
