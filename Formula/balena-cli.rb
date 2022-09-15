require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-14.3.0.tgz"
  sha256 "6b9ce0c55fa56d68c3aa41ceff1a0de41779ff5fa7794a34bb010c5166f69e82"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "03fc33f82b51c6e4e4a59692b2e25d7c16823d7b2f3e62d01cc0a855aa676772"
    sha256                               arm64_big_sur:  "0e579f04e06db961d8dcb2c4335697a013efd567d06f9d3255572dd42b5317cc"
    sha256                               monterey:       "a8d3ffc38ce4750abae9eba4555e485efa455c6031e7c2f7005b6f2df0d9b882"
    sha256                               big_sur:        "e7a00b0b72b2207701f58045ee39ab36da83582c7b913f23a1523fa835aa2a09"
    sha256                               catalina:       "e8e25abd9f60f121e70793c006ce2639c8431a7af9cf37c7c87cfffa3d48722a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed10f7bd40eeb587e76719df72fbb7c8860e0f3a3b082e31db08296877be7c19"
  end

  # Node looks for an unversioned `python` at build-time.
  depends_on "python@3.10" => :build
  depends_on "node@14"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@14"].opt_bin}:$PATH"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
