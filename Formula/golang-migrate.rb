class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.12.1.tar.gz"
  sha256 "df216d3df6461a6cfacf465296b3289db247b685b474296666d58555cf8e4752"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "53c9f1c0dfdf5dabb05feaed6b379e4d9c57dbbd8ead10392f125edd8b17c72b" => :catalina
    sha256 "790bd0091cfd117a99f6e8dd5e9991d74891c1915ac183dccc5a8dd9a4de7896" => :mojave
    sha256 "0b86ead888e2b925dc81ebc21ef871fd3bfe038fb2dd3f4f8c34a62d4c2d3d0f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
