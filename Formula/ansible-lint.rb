class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/59/c9/bebba18cfb0eb91208fbfaf44156225aa55bfe7f2dbd5afeb6f020fa5dcb/ansible-lint-6.9.0.tar.gz"
  sha256 "14ef919920c4acc980547ded0bd423a7a27a0b2327738e593343f446f3b126c6"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63a7ebc28ab5cd909ce8e20f791d6b16f5143ffd5a49c7246b77fbb5647bcb1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f557a9ff5f80508a087727471403f3e9fd884da2a12f7ab9dc8b2e29a41c286b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c19e545a62b9f18b61f4d1d1a6b6252489d04367e5415702f3a1ebb4bae70e86"
    sha256 cellar: :any_skip_relocation, ventura:        "109ed8dde333355ae97f544c215174af4363a4fc1482ebc826967ed20ec6fac2"
    sha256 cellar: :any_skip_relocation, monterey:       "91a8c36b424ea437187e5f3f355339ac93377b5690552054f37c8f1ce523c43e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff160c43d5098b1e6cb8a70084d0bb026de7107b8a8b90026ccb336a3f3de895"
    sha256 cellar: :any_skip_relocation, catalina:       "762cfdb670529a6bd7673d39889256bea32f22de761e0a8a259da824e9fc1163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0593442c02685142c0873b753f087fd8b4d8b51c00815640df1d369c01369daf"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "black"
  depends_on "jsonschema"
  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/37/1a/604884d3655a80476dff5ad3cc9991decc5fb26d3f5df51d38361c3cedb1/ansible-compat-2.2.5.tar.gz"
    sha256 "28c7c545fd60ef9c3059cfb2fefd27f92db091ff6b5868f83f121ceb5e1fe1b5"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/76/1b/653bc93bf15738ab2fe83a875d28354cbe7402b12e22801d35e5461fe3f2/subprocess-tee-0.4.0.tar.gz"
    sha256 "7ea885ff32cdb2b2d3b2a6c464492f2ee1ebbf324e50598d75de4f6f3ea0f149"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.10")
    %w[ansible black jsonschema yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: false
        tasks:
        - name: ping
          ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
