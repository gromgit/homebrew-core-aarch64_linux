class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.8.0.tar.gz"
  sha256 "c2ce573e9d83c128ed44a54406745ca7eead8d8be2b55592e489210bea3a4a0f"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5bb89bf54e0405bb8115ab20d10e9e88b24d6ed283e8c780c0e685f1ea3dd79" => :catalina
    sha256 "b5bb89bf54e0405bb8115ab20d10e9e88b24d6ed283e8c780c0e685f1ea3dd79" => :mojave
    sha256 "b5bb89bf54e0405bb8115ab20d10e9e88b24d6ed283e8c780c0e685f1ea3dd79" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "tarantool"

  def install
    system "cmake", ".", *std_cmake_args, "-DVERSION=#{version}"
    system "make"
    system "make", "install"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
