class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.0.tar.gz"
  sha256 "60a3c9cfa28fe5f02b42b17f6ccbe41cb18f3abc054a2de3c875099616fc8b88"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f04db0bcc7e58b5b738c234a5db2aad507919323458b8aec84ecb0f29aae61e" => :catalina
    sha256 "7869a87bbf7e4fede18ccdd22eb65f9a5ebceda795196666fc903e98bf3d150b" => :mojave
    sha256 "4ad98f91623a2b570e7a09e7eb927bccd6e56d7987e7dbea0bdb215bd9e2b7e9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
