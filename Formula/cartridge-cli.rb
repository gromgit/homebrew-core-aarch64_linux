class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.8.2.tar.gz"
  sha256 "28d98427d7d2cc72232cae501c9fe37ea5a8bf726b8e6d0d226a3714d53695a7"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d3487e6711821cb7324ea6b80a1360c5b8d6ccbbb4e5067275e6bb408282c0f" => :catalina
    sha256 "7d3487e6711821cb7324ea6b80a1360c5b8d6ccbbb4e5067275e6bb408282c0f" => :mojave
    sha256 "7d3487e6711821cb7324ea6b80a1360c5b8d6ccbbb4e5067275e6bb408282c0f" => :high_sierra
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
