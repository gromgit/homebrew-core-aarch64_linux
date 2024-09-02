class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.2.2.tar.gz"
  sha256 "4a1abe26c371a2db093831cdef56239ff2f191bdd387a75ffb71778e4af49791"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ferium"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0a34a8616cea09a830ea4ff254a2a0c9799b21bea28b792bd3535da3003f8ae9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ferium", "complete")
  end

  test do
    system "ferium", "--help"
    ENV["FERIUM_CONFIG_FILE"] = testpath/"config.json"
    system "ferium", "profile", "create",
                     "--game-version", "1.19",
                     "--mod-loader", "quilt",
                     "--output-dir", testpath/"mods",
                     "--name", "test"
    system "ferium", "add", "sodium"
    system "ferium", "list", "--verbose"
    system "ferium", "upgrade"
    !Dir.glob("#{testpath}/mods/*.jar").empty?
  end
end
