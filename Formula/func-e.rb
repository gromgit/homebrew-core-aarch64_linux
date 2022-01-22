class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v1.1.2.tar.gz"
  sha256 "4a7d5f295adc6715df37b2503b9fb73a08b683ebeab5bf9b120c4cbf6ad1423b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dff9cb95961a6101ca105bb8ad58c2ee265dc4a007e89d504e51df551e62494"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8dd906a8596a1f047d6a562811485051c2efbba187620c75cff290d48a5d4e4"
    sha256 cellar: :any_skip_relocation, monterey:       "28c867e0bf13ff93a353c8141d60b9d92b0a8f4ab6938a68d33541a700bc39c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0163769b7efffb5bcd490e31d804f8bc4ed08ccde48168af2d5f056f106aade"
    sha256 cellar: :any_skip_relocation, catalina:       "5a3988abb91fcc9c4a10e6ac5c44fbe2e26a0ef48bcbf708c6588133cb51421f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38c29a3290149b75f19d6ecdd31e9421e086af3e5fd0bb990580023551aef5e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    func_e_home = testpath/".func-e"
    ENV["FUNC_E_HOME"] = func_e_home

    # While this says "--version", this is a legitimate test as the --version is interpreted by Envoy.
    # Specifically, func-e downloads and installs Envoy. Finally, it runs `envoy --version`
    run_output = shell_output("#{bin}/func-e run --version")

    # We intentionally aren't choosing an Envoy version. The version file will have the last minor. Ex. 1.19
    installed_envoy_minor = (func_e_home/"version").read
    # Use a glob to resolve the full path to Envoy's binary. The dist is under the patch version. Ex. 1.19.1
    envoy_bin = func_e_home.glob("versions/#{installed_envoy_minor}.*/bin/envoy").first
    assert_path_exists envoy_bin

    # Test output from the `envoy --version`. This uses a regex because we won't know the commit etc used. Ex.
    # envoy  version: 98c1c9e9a40804b93b074badad1cdf284b47d58b/1.18.3/Modified/RELEASE/BoringSSL
    assert_match %r{envoy +version: [a-f0-9]{40}/#{installed_envoy_minor}\.[0-9]+/}, run_output
  end
end
