class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.5.1.tar.gz"
  sha256 "e547f3604bb801914d5685c22b54776baf70686b9aeb191396866a6e55391591"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7e86cf87ce4c1c401728d0bd49b6e912c5d5ee0f883402930019bcf71c574208" => :catalina
    sha256 "31fd0b30b4335b759c1bf8c15396fe6ecacbdd8a73341edeaf6d8b279ab61fe9" => :mojave
    sha256 "d6db46c8080be47294a04ea68d8071072639e29c5ccc134247bb05205eab0248" => :high_sierra
  end

  depends_on "rust" => [:build, :test]

  # Fixes crash issue with v2 Cargo.lock files - detected while building rav1e.
  # Remove with the next version.
  patch do
    url "https://github.com/lu-zero/cargo-c/commit/0cb09ac3c1950a2c05758b344131ff7b7a38c42d.patch?full_index=1"
    sha256 "746a6a9e6fc9a3b15afa9167011a2a06b9c70d7c9adbf7bb20b4e376fa0ab667"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "cargo", "cinstall", "--version"
  end
end
