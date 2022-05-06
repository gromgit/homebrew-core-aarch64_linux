class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.4.0.tgz"
  sha256 "fc65ce860b2a7c6386788b4f36ba9954e1a606c14f2667e805a003dc81c98e28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a3c504be6de65b21934dbeeefff2f5048a17a5558d060a350b6c6cf709ab85b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "966fb64df419e7f2271b748d2f30039765d08ba3f2754af2ef6e74b0733cb863"
    sha256 cellar: :any_skip_relocation, monterey:       "b1985364c98972f4246c6b582fedac8eb924f51a96f80545e18c5b7d8518c3e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ac407882b61f48535d3213adf549daa927c0aee00c9488ed9d28f57b24cfb29"
    sha256 cellar: :any_skip_relocation, catalina:       "17b2af50c0f617fd1acabc5741ac33859f9627fc9ca8f7ae209db204f7f267bf"
  end

  depends_on "bash" => :build
  depends_on "python@3.10" => :build
  depends_on "yarn" => :build
  depends_on "node@16"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    node = Formula["node@16"]
    system "yarn", "--production", "--frozen-lockfile"
    # @parcel/watcher bundles all binaries for other platforms & architectures
    # This deletes the non-matching architecture otherwise brew audit will complain.
    prebuilds = buildpath/"lib/vscode/node_modules/@parcel/watcher/prebuilds"
    (prebuilds/"darwin-x64").rmtree if Hardware::CPU.arm?
    (prebuilds/"darwin-arm64").rmtree if Hardware::CPU.intel?
    libexec.install Dir["*"]
    env = { PATH: "#{node.opt_bin}:$PATH" }
    (bin/"code-server").write_env_script "#{libexec}/out/node/entry.js", env
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  service do
    run opt_bin/"code-server"
    keep_alive true
    error_log_path var/"log/code-server.log"
    log_path var/"log/code-server.log"
    working_dir ENV["HOME"]
  end

  test do
    # See https://github.com/cdr/code-server/blob/main/ci/build/test-standalone-release.sh
    system bin/"code-server", "--extensions-dir=.", "--install-extension", "wesbos.theme-cobalt2"
    assert_match "wesbos.theme-cobalt2",
      shell_output("#{bin}/code-server --extensions-dir=. --list-extensions")
  end
end
