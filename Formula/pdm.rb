class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/45/24/163171e57f376af454a183c07377ea10336bd34c09f6e043f95668fce679/pdm-1.5.3.tar.gz"
  sha256 "44b4c94db4c32a369a66caa380e2ed88e9de4996c41142326b0c3f6f5ac29548"
  license "MIT"
  head "https://github.com/frostming/pdm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b201ae492be612de904279030b5734329ee9228a9042a803b8cfbc0188ade35"
    sha256 cellar: :any_skip_relocation, big_sur:       "2159d18bf0cb1a683195a66a5702dfba66ca6e7c94ab31b759489b668ae9b686"
    sha256 cellar: :any_skip_relocation, catalina:      "0f65853e220e1e719857dd2c911dc6446275e590d8dc0d0eaf3b07e0efe43c64"
    sha256 cellar: :any_skip_relocation, mojave:        "2c37267bc2e04584f2003a4dbd1c7c3f283b1ca1f04acee8442b046a25205090"
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/39/6f/4a3e1070bd193e9fa3d9a6b3977ac025579816344023d0d9f662583ffe77/pdm-pep517-0.7.4.tar.gz"
    sha256 "538409c63131d6c52ce8dc7dd3d78a033dcdad07f1c71f542add77e70fa9cb55"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0f/4c/ac5dc83e7afa327ea9b018a15193a4f1cd8bcce85263a60c127fdcf8ffd3/pep517-0.10.0.tar.gz"
    sha256 "ac59f3f6b9726a49e15a649474539442cf76e0697e39df4869d25e68e880931b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-cfonts" do
    url "https://files.pythonhosted.org/packages/b2/7c/8f0fa8f9047bf887bfb8c09b405e429674a4beee5683864cb21b0b8df14e/python-cfonts-1.5.0.tar.gz"
    sha256 "76db1912c65d322abf5ba7be939e7b0862d239d0dee7321a6afb003b26fc8f62"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/66/94/286b7b88e24a7a2f3e020234524e3dc3dfdba313f299054b24b8d4d39b77/python-dotenv-0.17.1.tar.gz"
    sha256 "b1ae5e9643d5ed987fc57cc2583021e38db531946518130777734f9589b3141f"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/0d/fc/8ce27504a863ec89478f953ee7293ad62e33c3ca0bb659cfc0ca1b37ff3b/pythonfinder-1.2.6.tar.gz"
    sha256 "21ffb77b152ae14c5c7d9b1c98c6df0a1a34d4b3e050da39f561224e7664a5f4"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/af/91/9c0a7a26d77806184980411f38243acf2611f9ff5c91e8f94ea437688e3a/resolvelib-0.7.0.tar.gz"
    sha256 "8840a8bf49fd56cff51398ebfe090e5d6aeaf4c4102472bff006aca7db470868"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/64/e0/6c8c96024d118cb029a97752e9a6d70bd06e4fd4c8b00fd9446ad6178f1d/tomlkit-0.7.0.tar.gz"
    sha256 "ac57f29693fab3e309ea789252fcce3061e19110085aa31af5446ca749325618"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  def install
    virtualenv_install_with_resources
    (bash_completion/"pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "bash")
    (zsh_completion/"_pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "zsh")
    (fish_completion/"pdm.fish").write Utils.safe_popen_read("#{bin}/pdm", "completion", "fish")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"

    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
