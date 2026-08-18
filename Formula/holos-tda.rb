class HolosTda < Formula
  desc "Vietoris-Rips persistent homology with an implicit ripser-class engine"
  homepage "https://github.com/t0rsion/holos"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.5.0/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "e151ec77d2efab8b026b4601c51c40c6572f087264bbe32c538b9843196f6719"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.5.0/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "c24fd4f40c000efb81e2f4e26deb21c5ef475447ac4c5b51114315d54a99ac55"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.5.0/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5715d47a0af41c44801a010a6945407e798cbc467e2b5741de33bdd85cd5bab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.5.0/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2281a19af147524f28f99c23e4cf906d5411d6cd6e59b64a28e736276b6d79c6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
