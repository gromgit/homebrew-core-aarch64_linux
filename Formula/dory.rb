class Dory < Formula
  desc "Development proxy for docker"
  homepage "https://github.com/freedomben/dory"
  url "https://github.com/FreedomBen/dory/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "1571e54dab39bc7884523aabeedde71921e64a11ef25b9c59a7b63282f97a237"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dory"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d65c174f584ea6dc2175b35a46978526e05067367986a47e57ed5d0f0948654b"
  end

  depends_on "ruby@2.7"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    shell_output(bin/"dory")

    system "#{bin}/dory", "config-file"
    assert_predicate testpath/".dory.yml", :exist?, "Dory could not generate config file"

    version = shell_output(bin/"dory version")
    assert_match version.to_s, version, "Unexpected output of version"
  end
end
