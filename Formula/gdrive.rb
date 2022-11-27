class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/2.1.1.tar.gz"
  sha256 "9092cb356acf58f2938954784605911e146497a18681199d0c0edc65b833a672"
  license "MIT"
  head "https://github.com/prasmussen/gdrive.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gdrive"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1f7e6d437b3b0c5ab06d8f0636878b7d4b8d68dd5ecfc001581cbeb278a63649"
  end

  depends_on "go" => :build

  patch do
    url "https://github.com/prasmussen/gdrive/commit/faa6fc3dc104236900caa75eb22e9ed2e5ecad42.patch?full_index=1"
    sha256 "ee7ebe604698aaeeb677c60d973d5bd6c3aca0a5fb86f6f925c375a90fea6b95"
  end

  def install
    system "go", "build", *std_go_args, "-mod=readonly"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
  end
end
